function SparseDynamicG2TT!(T::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    SparseDynamicG1TT!(T, y, x, params, steady_state)
@inbounds begin
end
    return nothing
end

