# ==============================================================================
# transformation_functions.jl
# Purpose: Type-stable Julia functions for high-performance data transformations
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

using Statistics
using DataFrames

"""
    annualized_mom_growth(log_series::Vector{Float64})::Vector{Float64}

Compute annualized month-over-month growth rate from log-level series.
Formula: πₜ = 1200 × (log Pₜ - log Pₜ₋₁)

Type-stable implementation with minimal allocations.

# Arguments
- `log_series`: Vector of log-transformed values

# Returns
- Vector of annualized m-o-m growth rates (first element is NaN)
"""
function annualized_mom_growth(log_series::AbstractVector{Float64})::Vector{Float64}
    n = length(log_series)
    growth = Vector{Float64}(undef, n)
    growth[1] = NaN  # No prior month
    
    @inbounds for t in 2:n
        growth[t] = 1200.0 * (log_series[t] - log_series[t-1])
    end
    
    return growth
end


"""
    yoy_growth(log_series::Vector{Float64})::Vector{Float64}

Compute year-over-year growth rate from log-level series.
Formula: πₜ = 100 × (log Pₜ - log Pₜ₋₁₂)

# Arguments
- `log_series`: Vector of log-transformed values

# Returns
- Vector of y-o-y growth rates (first 12 elements are NaN)
"""
function yoy_growth(log_series::AbstractVector{Float64})::Vector{Float64}
    n = length(log_series)
    growth = Vector{Float64}(undef, n)
    growth[1:12] .= NaN  # No prior 12 months
    
    @inbounds @simd for t in 13:n
        growth[t] = 100.0 * (log_series[t] - log_series[t-12])
    end
    
    return growth
end


"""
    level_change(series::Vector{Float64}, lag::Int=1)::Vector{Float64}

Compute simple difference in levels.
Formula: Δyₜ = yₜ - yₜ₋ₗ

# Arguments
- `series`: Vector of values in levels
- `lag`: Number of lags for differencing (default: 1)

# Returns
- Vector of level changes (first `lag` elements are NaN)
"""
function level_change(series::AbstractVector{Float64}, lag::Int=1)::Vector{Float64}
    n = length(series)
    changes = Vector{Float64}(undef, n)
    changes[1:lag] .= NaN
    
    @inbounds for t in (lag+1):n
        changes[t] = series[t] - series[t-lag]
    end
    
    return changes
end


"""
    compute_all_transforms_wrapper(data::Matrix{Float64}, 
                                  var_names::Vector{String},
                                  log_vars::Vector{String},
                                  level_vars::Vector{String})::DataFrame

Wrapper for R compatibility. Converts String vectors to Symbol vectors.
"""
function compute_all_transforms_wrapper(
    data::Matrix{Float64}, 
    var_names::Vector{String},
    log_vars::Vector{String},
    level_vars::Vector{String}
)::DataFrame
    return compute_all_transforms(
        data, 
        Symbol.(var_names), 
        Symbol.(log_vars), 
        Symbol.(level_vars)
    )
end


"""
    compute_all_transforms(data::Matrix{Float64}, 
                          var_names::Vector{Symbol},
                          log_vars::Vector{Symbol},
                          level_vars::Vector{Symbol})::DataFrame

Compute all evaluation transforms for a data matrix.
Applies appropriate transformation based on variable type.

# Arguments
- `data`: Matrix with variables in columns
- `var_names`: Names of all variables (in column order)
- `log_vars`: Names of variables in log-levels (need growth rates)
- `level_vars`: Names of variables in levels (need differences)

# Returns
- DataFrame with all transformed series
"""
function compute_all_transforms(
    data::Matrix{Float64}, 
    var_names::Vector{Symbol},
    log_vars::Vector{Symbol},
    level_vars::Vector{Symbol}
)::DataFrame
    
    n_obs = size(data, 1)
    results = Dict{Symbol, Vector{Float64}}()
    
    # Add original series
    for (i, var) in enumerate(var_names)
        results[var] = data[:, i]
    end
    
    # Compute growth rates for log variables
    for var in log_vars
        idx = findfirst(==(var), var_names)
        if !isnothing(idx)
            col = @view data[:, idx]
            results[Symbol(var, "_mom")] = annualized_mom_growth(col)
            results[Symbol(var, "_yoy")] = yoy_growth(col)
        end
    end
    
    # Compute differences for level variables
    for var in level_vars
        idx = findfirst(==(var), var_names)
        if !isnothing(idx)
            col = @view data[:, idx]
            results[Symbol(var, "_diff")] = level_change(col, 1)
            results[Symbol(var, "_diff12")] = level_change(col, 12)
        end
    end
    
    return DataFrame(results)
end


"""
    parallel_transform(data::Matrix{Float64}, 
                      log_indices::Vector{Int})::Matrix{Float64}

Compute m-o-m growth rates for multiple log-series in parallel.
Uses Julia's threading for additional speedup.

# Arguments
- `data`: Matrix with log-variables in columns
- `log_indices`: Column indices of log-variables

# Returns
- Matrix of annualized m-o-m growth rates
"""
function parallel_transform(
    data::Matrix{Float64}, 
    log_indices::Vector{Int}
)::Matrix{Float64}
    
    n_obs, n_vars = size(data)
    n_log_vars = length(log_indices)
    results = Matrix{Float64}(undef, n_obs, n_log_vars)
    
    # Parallel processing across variables
    Threads.@threads for i in 1:n_log_vars
        col_idx = log_indices[i]
        col = @view data[:, col_idx]
        results[:, i] = annualized_mom_growth(col)
    end
    
    return results
end


# ==============================================================================
# Helper Functions for RMSFE Calculation
# ==============================================================================

"""
    rmsfe(forecast::Vector{Float64}, actual::Vector{Float64})::Float64

Compute Root Mean Squared Forecast Error.
Handles missing values automatically.

# Arguments
- `forecast`: Vector of forecasted values
- `actual`: Vector of actual values

# Returns
- RMSFE scalar
"""
function rmsfe(forecast::AbstractVector{Float64}, actual::AbstractVector{Float64})::Float64
    @assert length(forecast) == length(actual) "Forecast and actual must have same length"
    
    errors = forecast .- actual
    
    # Remove NaN/missing
    valid_idx = .!(isnan.(errors))
    errors_clean = errors[valid_idx]
    
    if length(errors_clean) == 0
        return NaN
    end
    
    return sqrt(mean(errors_clean .^ 2))
end


"""
    mae(forecast::Vector{Float64}, actual::Vector{Float64})::Float64

Compute Mean Absolute Error.

# Arguments
- `forecast`: Vector of forecasted values
- `actual`: Vector of actual values

# Returns
- MAE scalar
"""
function mae(forecast::AbstractVector{Float64}, actual::AbstractVector{Float64})::Float64
    @assert length(forecast) == length(actual) "Forecast and actual must have same length"
    
    errors = abs.(forecast .- actual)
    valid_idx = .!(isnan.(errors))
    errors_clean = errors[valid_idx]
    
    if length(errors_clean) == 0
        return NaN
    end
    
    return mean(errors_clean)
end


# Print confirmation
println("✓ Julia transformation functions loaded successfully.")
println("  Available functions:")
println("    - annualized_mom_growth()")
println("    - yoy_growth()")
println("    - level_change()")
println("    - compute_all_transforms()")
println("    - parallel_transform()")
println("    - rmsfe()")
println("    - mae()")
