install.packages("pacman")
pacman::p_install(
    tidyverse, magrittr, rstatix, psych, # data wrangling
    caret, lavaan, ranger, ClusterR, modelbased, robust, # modelling
    httpgd, lintr, languageserver, # vcode
    DBI, dbplyr, RMariaDB, # database utilities
    broom, lm.beta, # model exploration
    knitr, kableExtra, learnr, rmarkdown, shiny, # reporting
    ggthemes, # plotting
    roxygen2, testthat, devtools, rlang, # programming
    force = FALSE
    )
devtools::install_github("crsh/papaja")
devtools::install_github("jakub-jedrusiak/jedrusiakr")
