% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stats-lm-tidiers.R
\name{tidy.lm}
\alias{tidy.lm}
\alias{lm_tidiers}
\title{Tidy a(n) lm object}
\usage{
\method{tidy}{lm}(x, conf.int = FALSE, conf.level = 0.95, ...)
}
\arguments{
\item{x}{An \code{lm} object created by \code{\link[stats:lm]{stats::lm()}}.}

\item{conf.int}{Logical indicating whether or not to include a confidence
interval in the tidied output. Defaults to \code{FALSE}.}

\item{conf.level}{The confidence level to use for the confidence interval
if \code{conf.int = TRUE}. Must be strictly greater than 0 and less than 1.
Defaults to 0.95, which corresponds to a 95 percent confidence interval.}

\item{...}{Additional arguments. Not used. Needed to match generic
signature only. \strong{Cautionary note:} Misspelled arguments will be
absorbed in \code{...}, where they will be ignored. If the misspelled
argument has a default value, the default value will be used.
For example, if you pass \code{conf.lvel = 0.9}, all computation will
proceed using \code{conf.level = 0.95}. Additionally, if you pass
\code{newdata = my_tibble} to an \code{\link[=augment]{augment()}} method that does not
accept a \code{newdata} argument, it will use the default value for
the \code{data} argument.}
}
\description{
Tidy summarizes information about the components of a model.
A model component might be a single term in a regression, a single
hypothesis, a cluster, or a class. Exactly what tidy considers to be a
model component varies across models but is usually self-evident.
If a model has several distinct types of components, you will need to
specify which components to return.
}
\details{
If the linear model is an \code{mlm} object (multiple linear model),
there is an additional column \code{response}. See \code{\link[=tidy.mlm]{tidy.mlm()}}.
}
\examples{

library(ggplot2)
library(dplyr)

mod <- lm(mpg ~ wt + qsec, data = mtcars)

tidy(mod)
glance(mod)

# coefficient plot
d <- tidy(mod) \%>\%
  mutate(
    low = estimate - std.error,
    high = estimate + std.error
  )

ggplot(d, aes(estimate, term, xmin = low, xmax = high, height = 0)) +
  geom_point() +
  geom_vline(xintercept = 0) +
  geom_errorbarh()

augment(mod)
augment(mod, mtcars)

# predict on new data
newdata <- mtcars \%>\%
  head(6) \%>\%
  mutate(wt = wt + 1)
augment(mod, newdata = newdata)

# predict on new data without outcome variable. Output does not include .resid
newdata <- newdata \%>\%
  select(-mpg)
augment(mod, newdata = newdata)

au <- augment(mod, data = mtcars)

ggplot(au, aes(.hat, .std.resid)) +
  geom_vline(size = 2, colour = "white", xintercept = 0) +
  geom_hline(size = 2, colour = "white", yintercept = 0) +
  geom_point() +
  geom_smooth(se = FALSE)

plot(mod, which = 6)
ggplot(au, aes(.hat, .cooksd)) +
  geom_vline(xintercept = 0, colour = NA) +
  geom_abline(slope = seq(0, 3, by = 0.5), colour = "white") +
  geom_smooth(se = FALSE) +
  geom_point()

# column-wise models
a <- matrix(rnorm(20), nrow = 10)
b <- a + rnorm(length(a))
result <- lm(b ~ a)
tidy(result)
}
\seealso{
\code{\link[=tidy]{tidy()}}, \code{\link[stats:summary.lm]{stats::summary.lm()}}

Other lm tidiers: 
\code{\link{augment.glm}()},
\code{\link{augment.lm}()},
\code{\link{glance.glm}()},
\code{\link{glance.lm}()},
\code{\link{glance.svyglm}()},
\code{\link{tidy.glm}()},
\code{\link{tidy.lm.beta}()},
\code{\link{tidy.mlm}()}
}
\concept{lm tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with columns:
  \item{conf.high}{Upper bound on the confidence interval for the estimate.}
  \item{conf.low}{Lower bound on the confidence interval for the estimate.}
  \item{estimate}{The estimated value of the regression term.}
  \item{p.value}{The two-sided p-value associated with the observed statistic.}
  \item{statistic}{The value of a T-statistic to use in a hypothesis that the regression term is non-zero.}
  \item{std.error}{The standard error of the regression term.}
  \item{term}{The name of the regression term.}

}
