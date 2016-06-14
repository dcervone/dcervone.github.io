setwd("~/git/xy/XYHoops/dlc_src/new/scripts")
source("../util/fit_util.R")
source("../util/EPV_util.R")

shots <- read.csv("~/data/nba_shots_ex.csv")
players <- read.csv(players.file)

par(mar=c(0,0,0,0))
plot(16, 35, pch=16, xaxt="n", yaxt="n", xlab="", ylab="", bty="n", xlim=c(0, 47), ylim=c(0, 50), cex=2)
draw.halfcourt()

with(shots[which(shots$entity == 509450), ], 
  points(x, y, col="#A9BCF5", pch=16))
# text(38, 48, "DeMarcus Cousins", col="#A9BCF5")
#with(shots[which(shots$entity == 253975), ], 
#     points(x, y, col="#FA8258", pch=16))
draw.halfcourt()
with(shots[which(shots$entity == 266554), ], 
     points(x, y, col="#FA8258", pch=16))
draw.halfcourt()

# load EPV DEMO stuff
this.player <- grep("Dwight Howard", paste(players$firstname, players$lastname))

vars <- paste0("b", seq(n.basis))
spat.fixed <- as.numeric(inla.out$summary.fixed["(Intercept)", "mean"] + 
                           t(take.basis) %*% inla.out$summary.fixed[vars, "mean"])
spat.random <- as.numeric(inla.out$summary.random$p.int[this.player, "mean"] + 
                            t(take.basis) %*% inla.out$summary.random$p.int[this.player + n * (1:n.basis), "mean"])

par(mfrow=c(1,1))
spatialPlot1(spat.random + spat.fixed, legend=F)


n <- seq(25, 650, 25)
y.m <- rep(.275, length(n))
y.h <- qbinom(.975, size=n, prob=y.m) / n
y.l <- qbinom(.025, size=n, prob=y.m) / n

y.df <- data.frame(n, y.m, y.h, y.l)
library(ggplot2)
ggplot(y.df, aes(x=n, y=y.m)) + geom_line() + ylim(.15, .4) + 
  geom_smooth(data=y.df[-1, ], aes(x=n, y=y.h), se=F) + 
  geom_smooth(data=y.df[-1, ], aes(x=n, y=y.l), se=F) + 
  labs(x = "# at bats", y = "Batting average", title = "A true 0.275 hitter's batting average during a season")












