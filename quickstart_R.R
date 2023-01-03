if (!require("pacman")) install.packages("pacman")

pacman::p_load(
    tidyverse, magrittr, rstatix, psych, # data wrangling
    caret, lavaan, ranger, ClusterR, modelbased, robust, # modelling
    httpgd, lintr, languageserver, # vcode
    DBI, dbplyr, RMariaDB, # database utilities
    broom, lm.beta, # model exploration
    rmarkdown, knitr, shiny, kableExtra, learnr, # reporting
    ggthemes, # plotting
    roxygen2, testthat, devtools, rlang # programming
    )

devtools::install_github("crsh/papaja")
devtools::install_github("jakub-jedrusiak/jedrusiakr")

devtools::update_packages(upgrade = TRUE)

quit(save = "no")