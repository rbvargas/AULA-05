# API  (FORMA DE ACESSO)
# DADOS DO BANCO MUNDIAL (WORLD BANK)
# WORLD DEVELOPMENT INDICATORS (BASE DE DADOS)

# NA AULA PASSADA, ACESSAMOS OS DADOS DO PIB
# PRODUTO INTERNO BRUTO
library(WDI) # CARREGAR A BIBLIOTECA/PACOTE
options(scipen = 999) # AJUTAR A NOT. CIENT.

dadospib <- WDI(country = "all",
                indicator = "NY.GDP.MKTP.CD")

basepib2023 <- WDI(country = 'all',
                   indicator = 'NY.GDP.MKTP.CD',
                   start = 2023, end = 2023)

dadospib <- WDI(country = "BR",
                indicator = "NY.GDP.MKTP.CD")

# Taxa de mortalidade por suicídio, homens
library(WDI) 

# DADOS EM PAINEL
taxasuicidio <- WDI(country = "all",
              indicator = "SH.STA.SUIC.MA.P5")

# CORTE TRANSVERSAL 
taxasuicidio2015 <- WDI(country = "all",
                       indicator = "SH.STA.SUIC.MA.P5",
                       start = 2015, end = 2015)

# SÉRIE TEMPORAL 
taxasuicidio2015 <- WDI(country = "BR",
                         indicator = "SH.STA.SUIC.MA.P5",
                         start = 2015, end = 2015)

