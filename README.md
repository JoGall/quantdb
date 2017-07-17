quantdb
=======

Maintains and updates a PostgreSQL database of stock market data gathered with the [`quantmod`](https://github.com/joshuaulrich/quantmod) package for R.

Schema structure follows SQL industry standards with separate layers for loading raw CSVs to an external table (`ss_ext.ext_price`), casting into a staging table (`ss_stg.stg_price`), and loading into a target table (`ss.price`). More detailed company data are also loaded into another table (`ss.info`) ready to be joined with the `ss.price` table, e.g.:

```{psql}
SELECT * FROM ss.price
  AS t1
INNER JOIN ss.info
  AS t2 
  ON t1.symbol = t2.symbol
;
```

-----

#### Install dependencies

Requires an installation of [R](https://cran.r-project.org/mirrors.html) and [PostgreSQL](https://www.postgresql.org/download/), and R packages `dplyr` and [`quantmod`](https://github.com/joshuaulrich/quantmod) R package:
```R
require(dplyr)
require(devtools)
devtools::install_github("joshuaulrich/quantmod")
```

#### Set parameters in ./config.sh
Set global parameters in './config.sh', including directory database parameters (host, user, database, password), start date to return stock data from, and a list of ticker [symbols](https://en.wikipedia.org/wiki/Ticker_symbol) you're interested in getting data for. See [`./R/build_my_symbols_ex.R`](https://github.com/JoGall/quantdb/blob/master/R/build_my_symbols_ex.R) script for an example of getting symbols using `quantmod` and [`my_symbols.txt`](https://github.com/JoGall/quantdb/blob/master/my_symbols.txt) for an example file.

#### Initial database build using ./buildDB.sh
After setting global parameters, build a new database (or overwrite an existing database) using:

`./buildDB.sh`

#### Update database using ./updateDB.sh
Once a database has been created, you can update it using:

`./updateDB.sh`

This could be automated e.g. weekly with a [job scheduler](https://en.wikipedia.org/wiki/List_of_job_scheduler_software).


-----

###### Contact

* **website / blog:** [jogall.github.io](https://jogall.github.io/)
* **email:**  joedgallagher [at] gmail [dot] com
* **twitter:**  @joedgallagher
