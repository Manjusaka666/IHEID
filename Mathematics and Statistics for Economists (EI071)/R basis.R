a = 3
b = 8

isAlargerB = a>b
typeof(isAlargerB)

a<b
a>=b
a==b
a!=b

isAlargerB = 0
isXtrue = TRUE
isYtrue = FALSE
isXnottrue = !isXtrue
isYnottrue = !isYtrue
areBothTrue = isXtrue & isYtrue
isEitherTrue = isXtrue | isYtrue
isExactlyOneTrue = xor(isXtrue, isYtrue)

fMultiplyxy = function(x, y){
  return(x*y)
}

fMultiplyxy(3, 8)
fMultiplyxy(x=3, y=8)

v_x = c(1, 2, 3, 4, 5)
v_y = c(6, 7, 8, 9, 10)
vx = 1:3
show(vx)
t(vx)
c(vx, v_y)
seq(-4, 4, by=0.8)
rep(1, 5)
rev(v_x)

vx = c(TRUE,FALSE)

vx = c(1,2,3)
vy = c(1,3,3)
vx+vy
vy/3
vx*vy
vx%*%t(vy)
t(vx)%*%vy


min(vx)
max(vx)
prod(vx)
var(vx)
sd(vx)
mean(vx)
cor(vx, vy)

vx = c(1,2,NA,2,3)
mean(vx)
mean(vx, na.rm=TRUE)

vy[c(1,3)]
vy[-c(1,3)]
vy[c(FALSE, TRUE, FALSE)]

vy[vy>=2]
names(vy) = c("a", "b", "c")
vy["a"]
vy["b"]

vy[c("a", "c")]=c(6, 7)
which.min(vy)
which(vy==3)

sort(vy,decreasing=TRUE)

vx = c(1,3,4,2)
vy = c(1,3,5)
vx+vy
cor(vx,vy)

matrix(1:6, nrow=2, ncol=3)
matrix(c(1,4,3,7,8,6), nrow=2, ncol=3)
matrix(c(1,4,3,7,8,6), nrow=2, ncol=3, byrow=TRUE)

diag(3)
diag(c(3,2))
mA = matrix(1:6, nrow=2, ncol=3)
diag(mA)

mA = matrix(c(1,3,8,8), nrow=2, ncol=2)
mB = matrix(c(1,2,7,1), nrow=2, ncol=2)
mA+mB
mA*mB
mA%*%mB
t(mA)
solve(mA)

qr(mA)$rank
eigen(mA)
eigen(mA)$values
eigen(mA)$vectors

apply(mA, 2, mean)
apply(mA, 1, mean)

aX = 1:12
dim(aX) = c(2,3,2)
show(aX)

aX[1,3,2]

a = 4

if (a==2){
  print("a is 2")
} else if (a==3){
  print("a is 3")
} else {
  print("a is not 2 or 3")
}

#Loops
a = 0
for (i in 1:5){
  a = a + i
}
print(a)

a = 0
while (a<10){
  a = a + 1
}
print(a)

a = 0
for (i in 1:10){
  if (i%%2 == 0){
    next
  }
  a = a + i
}
print(a)

while (a<130){
  a = a + 3
  print(a)
  if (a == 88 | a == 89){
    break
  }
}

a = "banana"
typeof(a)
length(a)
nchar(a)
substr(a, 1, 3)
as.character(3)
format(3, nsmall=2)

paste("mouse=", 3)

strsplit("Mississippi", "i")
gsub("i", "o", "Mississippi")

library("lubridate")
year(today())
newdate = as.Date("01-01-2018", format="%d-%m-%Y")
newdate
newdate + years(1)

MyList = list(1, "a", c(1,2,3))
MyList[3]
MyList = append(MyList, "b")

data(mtcars)
ncol(mtcars)
nrow(mtcars)
summary(mtcars)
vIsHPhigh = mtcars$hp > mean(mtcars$hp)
sum(vIsHPhigh)

mtcars[vIsHPhigh,]
nrow(mtcars[vIsHPhigh,])

mtcars[order(mtcars$cyl,mtcars$hp),]

df1 = data.frame(country=c("Zim","Cam","Rwa","Uga"), year=rep(2018,4), data=(1:4))

df2 = cbind(df1, outcome2=c(1,0,0,1))
df3 = subset(df2, select=-c(outcome2))
df1 = rbind(df1, list("Ken", 2018, 5))
df1 = df1[df1$country!="Rwa",]


FuncOpt = function(v){
  (v-3)^2
}

o = optimise(FuncOpt, interval = c(-10, 10))


