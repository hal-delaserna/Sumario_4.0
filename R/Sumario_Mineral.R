# rm(list = ls())
library(tidyverse)
library(rmarkdown)
#library(pdflatex)
library(kableExtra)
#library(tabulizer)
#library("readxl")
options(editor = 'notepad')


#  CARREGAMENTO ----

#  AMB ----
 source('D:/Users/humberto.serna/Documents/D_Lake/Dados_Abertos_ANM/AMB_Dados_Abertos.R')

#  Reservas Nacionais ----
reserva_AMB <-
  read.table(
    "D:/Users/humberto.serna/Documents/D_Lake/Reserva_AMB_BR_20210828.csv",
    header = TRUE,sep = ";",dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'UTF-8',fill = TRUE,
    quote = "")

reserva_AMB$Município.Mina <- 
  paste(
    str_to_title(reserva_AMB$Município.Mina), 
    reserva_AMB$UF.Mina, sep = "-")


reserva_AMB$Município.Mina <- 
  gsub(reserva_AMB$Município.Mina, pattern = " Do ", replacement = " do ") %>% 
  gsub(pattern = " Dos ", replacement = " dos ") %>% gsub(pattern = " Da ", replacement = " da ") %>% 
  gsub(pattern = " Das ", replacement = " das ") %>% gsub(pattern = " De ", replacement = " de ")
  


colnames(reserva_AMB) <-
  c("ano", "cpfcnpj", "uf", "municipio", "substancia.agrupadora", "substancia.amb", 
    "unidade.do.contido", "massa.medida", "contido.medido", "massa.indicada", "contido.indicado", 
    "massa.inferida", "contido.inferido", "massa.lavravel", "contido.lavravel")


# Produção e Reservas Mundiais - Fonte: USGS / World Mining Data ----

##sheet_names <- 
#  excel_sheets("./D_Lake/World_Mining_Data_6.4.xlsx")
#
#lista <- list()
#for (i in 1:length(sheet_names)) {
#  
#  df <- 
#    as.data.frame(
#      read_xlsx("./D_Lake/World_Mining_Data_6.4.xlsx", sheet = sheet_names[i], skip = 1, trim_ws = T))
#  
#  df$substancia <- sheet_names[i]
#  
#  lista[[i]] <- df
#  
#}

World_Mining_Data <- 
  read.table(
    "D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/df_WMD_Producao.csv",
    header = TRUE,sep = ";",dec = ",",
    colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","character","character"),
    stringsAsFactors = FALSE,
    encoding = 'UTF-8',fill = TRUE,
    quote = "")

  


#_____ Tabela de Compatibilidade de Nomes

Tabela_de_Compatibilidade_de_Nomes <-
  read.table(
    "D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Tabela_de_Compatibilidade_de_Nomes.csv",
    header = TRUE,sep = ";",dec = ",",
    stringsAsFactors = FALSE, 
    encoding = 'ANSI', fill = TRUE,
    quote = "")


World_Mining_Data <- 
  left_join(World_Mining_Data, Tabela_de_Compatibilidade_de_Nomes[,c("WDM", "substancia.agrupadora")], by = c("substancia" = "WDM"))

WMD <- 
  na.omit(
    summarise(
      group_by(World_Mining_Data, substancia.agrupadora, Country), 
          `2015` = sum(`X2015`),
          `2016` = sum(`X2016`),
          `2017` = sum(`X2017`),
          `2018` = sum(`X2018`),
          `2019` = sum(`X2019`)))



WMD <- 
  gather(WMD, key = "Ano", value = "Produção", -c(1,2))


# Países_Tradução
Países_Tradução <-
  read.table(
    "D:/Users/humberto.serna/Documents/D_Lake/Países_Tradução.csv",
    header = TRUE,sep = ";",dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'ANSI',fill = TRUE,
    quote = "")

WMD <- 
  left_join(WMD, Países_Tradução, by = c("Country" = "Inglês"))


WMD$Country <- WMD$Português
WMD <- 
  WMD[,c("substancia.agrupadora", "Country", "Ano", "Produção")]

# Reservas Mundiais ----

reservas_USGS <-
  read.table(
    file = "D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/df_USGS_Reservas.csv",
    header = TRUE, sep = ";", dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'ANSI', fill = TRUE)

reservas_USGS <- 
 left_join(reservas_USGS, Países_Tradução, by = c("pais" = "Inglês"))

reservas_USGS <- 
  left_join(reservas_USGS, 
            Tabela_de_Compatibilidade_de_Nomes[,c("USGS", "substancia.agrupadora")], 
            by = c("substancia" = "USGS"))


  
# ComexStat ----


# __________ Exportacoes_Totais ----
Exportacoes_Totais <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Exportações Totais.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Exportacoes_Totais_Paises <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Exportações Totais Países.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
# __________ Importacoes_Totais ----
Importacoes_Totais <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Importações Totais.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Importacoes_Totais_Paises <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Importações Totais Países.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Saldo_da_Balança_de_Bens <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Saldo da Balança de Bens.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Exportacoes_por_NCM <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Exportações Totais por NCM.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Importacoes_por_NCM <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Importações Totais por NCM.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Preco_Exportacao <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Preço Mediano de Exportação.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Preco_Importacao <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Preço Mediano de Importação.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Exportacao_Fator_Agregacao <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Exportações Totais por Fator de Agregação.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
Importacao_Fator_Agregacao <- 
  read.table("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Importações Totais por Fator de Agregação.csv", 
             header = TRUE, sep = ';', dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")


# Ajustes intrínscos às substâncias ---

# GRAFITA símbolo químico
producaoBENEFICIADA[
  producaoBENEFICIADA$substancia == "Grafita",
  ]$indicacao.contido <- "C"

# Bauxita

Exportacoes_Totais[Exportacoes_Totais$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Exportacoes_Totais_Paises[Exportacoes_Totais_Paises$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Importacoes_Totais[Importacoes_Totais$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Importacoes_Totais_Paises[Importacoes_Totais_Paises$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Saldo_da_Balança_de_Bens[Saldo_da_Balança_de_Bens$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Exportacoes_por_NCM[Exportacoes_por_NCM$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Importacoes_por_NCM[Importacoes_por_NCM$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Preco_Exportacao[Preco_Exportacao$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Preco_Importacao[Preco_Importacao$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Exportacao_Fator_Agregacao[Exportacao_Fator_Agregacao$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"
Importacao_Fator_Agregacao[Importacao_Fator_Agregacao$SUBSTANCIA == "Bauxita",]$SUBSTANCIA <- "Alumínio (Bauxita)"


# Dolomito e Magnesita s/ comex Conversar AdhelBar

# Monazita e Terras-Raras	s/ comex Conversar AdhelBar





# CICLO DE GERAÇÃO DOS RELATÓRIOS ---- 
#  "Areia",    
#  "Rochas (Britadas) e Cascalho",
#  "Rochas Ornamentais", não consta Rochas Ornamentais nos relatórios da USGS

s <- c(
       "Alumínio (Bauxita)",
       "Calcário",
       "Caulim",
        "Carvão Mineral",
        "Chumbo",
         "Cobalto",
         "Cobre",
         "Cromo",
          "Dolomito e Magnesita",
         "Estanho",
         "Ferro",
         "Fosfato",
         "Grafita",
         "Lítio",
         "Manganês",
         "Monazita e Terras-Raras",
         "Nióbio",
         "Níquel",
         "Ouro",
        "Potássio",
         "Prata",
          "Tântalo",
         "Titânio",
         "Tungstênio",
         "Vanádio",
         "Zinco",
        "Zircônio"
)

metadados = data.frame(
  "SUBS" = NA,
  "escala_ContidoMedido" = NA,
  "escala_ContidoMedido_Ano_Anterior" = NA,
  "escala_ContidoMedido_MUN" = NA,
  "escala_ContidoMedido_UF" = NA,
  "unidade_ProducaoBENEFICIADA" = NA,
  "escala_ProducaoBENEFICIADA" = NA,
  "escala_ProducaoBENEFICIADA_ANO" = NA,
  "escala_ProducaoBENEFICIADA_UF" = NA,
  "unidade" = NA,
  "thousandMT_Prod" = NA,
  "escala_ProducaoCONTIDO" = NA,
  "escala_ProducaoCONTIDO_ANO" = NA,
  "escala_ProducaoCONTIDO_UF" = NA,
  "escala_ReservaMedida" = NA,
  "escala_ReservaMedida_Ano_Anterior" = NA,
  "escala_ReservaMedida_MUN" = NA,
  "escala_ReservaMedida_UF" = NA
)


ANO <- 2018
for (SUBS in s) {
  
# Ciclo determinação de variáveis  
  source('D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumario_Mineral_Variaveis.R')

# Ciclo de renderização dos relatórios
  nome <- 
    stri_trans_general(SUBS, 'latin-ascii')
  
  
  if (SUBS %in% c(
    "Areia",
    "Rochas (Britadas) e Cascalho",
    "Calcário",
    "Carvão Mineral",
    "Caulim",
    "Dolomito e Magnesita",
    "Rochas Ornamentais",
    "Monazita e Terras-Raras"
  )) {
     rmarkdown::render(
    #  bookdown::render_book(output_format = "html_book", 
      input = 'D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Novo_Sumario_Mineral_A_MKD.Rmd',
      output_file =  paste0(nome, ".htm")
    )
    
  } else {
    rmarkdown::render(
      'D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown_2019(2018)/Novo_Sumario_Mineral_B_MKD.Rmd',
      output_file =  paste0(nome, ".htm")
    )
  }
} 



#  ______________________________________________________________________________ ----
   #   APÊNDICE: Extração das tabelas USGS _________________________________________ ---- 

# source('Sumario_Mineral_Extração_Tabelas_USGS.R')
