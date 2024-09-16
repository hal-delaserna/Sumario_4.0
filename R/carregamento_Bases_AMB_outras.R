# rm(list = ls())
library(tidyverse)
# source("./Funcoes_AMB/Funcoes_de_Formatacao_Estilo.R")

# CARREGANDO Reserva AMB ----

reserva_AMB <-
  read.table(
    "D:/Users/humberto.serna/Documents/D_Lake/DBAMB_Reservas_SP.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = "")
reserva_AMB <- reserva_AMB[,c(1:10,12:15,11,16:19)]


colnames(reserva_AMB) <-
  colnames(reserva_AMB) %>% FUNA_removeAcentos()

colnames(reserva_AMB) <-
  c("ano",
    "titular",
    "cpfcnpj",
    "processo",
    "mina",
    "municipio",
    "uf",
    "substancia.amb",
    "substancia.ral",
    "minerio",
    "massa.medida",
    "massa.indicada",
    "massa.inferida",
    "massa.lavravel",
    "unidade.contido",
    "contido.medido",
    "contido.indicado",
    "contido.inferido",
    "contido.lavravel"
    ) %>% FUNA_minusculas()

reserva_AMB$municipio <-
  reserva_AMB$municipio %>% FUNA_removeAcentos() %>% FUNA_minusculas()

reserva_AMB$titular <-
  reserva_AMB$titular %>% FUNA_removeAcentos() %>% FUNA_minusculas()

reserva_AMB$substancia.amb <-
  reserva_AMB$substancia.amb %>% FUNA_removeAcentos() %>% FUNA_minusculas()

reserva_AMB$substancia.ral <-
  reserva_AMB$substancia.ral %>% FUNA_removeAcentos()

reserva_AMB$minerio <-
  reserva_AMB$minerio %>% FUNA_removeAcentos() 

reserva_AMB$mina <-
  reserva_AMB$mina %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()

reserva_AMB$municipio <-
  gsub(reserva_AMB$municipio,
       pattern = "sao luiz do paraitinga",
       replacement = "sao luis do paraitinga")


#_____acrescentando percentil de reserva ----
reserva_AMB$id_subs.ano <-
  paste(reserva_AMB$substancia.amb, reserva_AMB$ano, sep = "_")

reserva_AMB <-
  left_join(
    reserva_AMB,
    select(reserva_AMB, ano, id_subs.ano, massa.medida) %>%
      group_by(id_subs.ano) %>%
      summarise("percentil_80" = quantile(
        massa.medida, probs = 0.8, na.rm = TRUE
      )),by = "id_subs.ano")

 # valores > 80%, pareto = 1
reserva_AMB$pareto <- 0
for (i in 1:nrow(reserva_AMB)) {
  
  if (reserva_AMB$massa.medida[i] > reserva_AMB$percentil_80[i]) {
    reserva_AMB$pareto[i] <- 1   
  }} 





# CARREGANDO Produ??o BRUTA ----

producaoBRUTA <-
  read.table(
    "D:/Users/humberto.serna/Documents/D_Lake/DBAMB_MovimentacaoProducaoBruta.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = ""
  )


colnames(producaoBRUTA) <-
  colnames(producaoBRUTA) %>% FUNA_removeAcentos()
colnames(producaoBRUTA) <-
  c(
    "ano",
    "cpfcnpj",
    "processo",
    "mina",
    "municipio",
    "uf",
    "substancia.amb",
    "substancia.ral",
    "minerio",
    "unidade.contido",
    "quantidade.Producao.Ajuste",
    "quantidade.Producao.Substancia.Ajuste",
    "valor.Venda.Minerio.Ajuste",
    "quantidade.Venda.Substancia.Ajuste",
    "valor.Venda.Substancia.Ajuste",
    "quantidade.Venda.Ajuste",
    "contido.substancia"
    )  %>% FUNA_minusculas()




producaoBRUTA$municipio <-
  producaoBRUTA$municipio %>% FUNA_removeAcentos() %>% FUNA_minusculas()


producaoBRUTA$substancia.amb <-
  producaoBRUTA$substancia.amb %>% FUNA_removeAcentos() %>% FUNA_minusculas()

producaoBRUTA$mina <-
  producaoBRUTA$mina %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()



#_____acrescentando percentil de produ??o ----
producaoBRUTA$id_subs.ano <-
  paste(producaoBRUTA$substancia.amb, producaoBRUTA$ano, sep = "_")

producaoBRUTA <-
  left_join(
    producaoBRUTA,
    select(producaoBRUTA, ano, id_subs.ano, quantidade.producao.ajuste) %>%
      group_by(id_subs.ano) %>%
      summarise("percentil_80" = quantile(
        quantidade.producao.ajuste, probs = 0.8, na.rm = TRUE
      )),by = "id_subs.ano")

# valores > 80%, pareto = 1
producaoBRUTA$pareto <- 0
for (i in 1:nrow(producaoBRUTA)) {
  
  if (producaoBRUTA$quantidade.producao.ajuste[i] > producaoBRUTA$percentil_80[i]) {
    producaoBRUTA$pareto[i] <- 1   
  }} 

# Valor Unit?rio de Venda
producaoBRUTA$preco <-
  round(producaoBRUTA$valor.venda.substancia.ajuste / 
          producaoBRUTA$quantidade.venda.substancia.ajuste, digits = 1)




# CARREGANDO Produ??o BENEFICIADA ----

producaoBENEFICIADA <-
  read.table(
    "D:/Users/humberto.serna/Documents/D_Lake/DBAMB_MovimentacaoProducaoBeneficiada.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = ""
  )


colnames(producaoBENEFICIADA) <-
  c(
    "ano",
    "cpfcnpj",
    "municipio",
    "uf",
    "usina",
    "minerio.principal.usina",
    "produto.pre.beneficiado.minerio",
    "substancia.amb",
    "unidade.teor",
    "quantidade.producao.substancia.ajuste",
    "contido.substancia",
    "quantidade.venda.substancia.ajuste",
    "valor.venda.ajuste.por.substancia",
    "quantidade.producao.ajuste",
    "quantidade.venda.ajuste",
    "valor.venda.ajuste.por.produto.pre.beneficiado.valor")


# minusculas
producaoBENEFICIADA$municipio <-
  producaoBENEFICIADA$municipio %>% FUNA_removeAcentos() %>% FUNA_minusculas()

producaoBENEFICIADA$substancia.amb <-
  producaoBENEFICIADA$substancia.amb %>% FUNA_removeAcentos() %>% FUNA_minusculas()

producaoBENEFICIADA$usina <-
  producaoBENEFICIADA$usina %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()

# ID cpf/cnpj- USINA

producaoBENEFICIADA$id_cpfcnpj.usina <- 
  paste(producaoBENEFICIADA$cpfcnpj, producaoBENEFICIADA$usina, sep = "_")

# ID cpf/cnpj- municipio

producaoBENEFICIADA$id_cpfcnpj.municipio <- 
  paste(producaoBENEFICIADA$cpfcnpj, producaoBENEFICIADA$municipio, sep = "_")


#_____acrescentando percentil de produ??o ----
producaoBENEFICIADA$id_subs.ano <-
  paste(producaoBENEFICIADA$substancia.amb, producaoBENEFICIADA$ano, sep = "_")

producaoBENEFICIADA <-
  left_join(
    producaoBENEFICIADA,
    select(producaoBENEFICIADA, ano, id_subs.ano, quantidade.producao.ajuste) %>%
      group_by(id_subs.ano) %>%
      summarise("percentil_80" = quantile(
        quantidade.producao.ajuste, probs = 0.8, na.rm = TRUE
      )),by = "id_subs.ano")

# valores > 80%, pareto = 1
producaoBENEFICIADA$pareto <- 0
for (i in 1:nrow(producaoBENEFICIADA)) {
  
  if (producaoBENEFICIADA$quantidade.producao.ajuste[i] > producaoBENEFICIADA$percentil_80[i]) {
    producaoBENEFICIADA$pareto[i] <- 1   
  }} 


# Valor Unit?rio de Venda
producaoBENEFICIADA$preco <-
  round(producaoBENEFICIADA$valor.venda.ajuste.por.substancia / 
          producaoBENEFICIADA$quantidade.venda.substancia.ajuste, digits = 1)

# excluindo usinas sem produ??o (inclusive as usinas autom?ticas criadas redundantemente)
linhas <- list()
for (i in 1:nrow(producaoBENEFICIADA)) {
  if (sum(
    producaoBENEFICIADA[i, c(
      "quantidade.producao.substancia.ajuste",
      "contido.substancia",
      "quantidade.venda.substancia.ajuste",
      "valor.venda.ajuste.por.substancia",
      "quantidade.producao.ajuste",
      "quantidade.venda.ajuste",
      "valor.venda.ajuste.por.produto.pre.beneficiado.valor"
    )], na.rm = TRUE) == 0) {
    linhas[i] <- i
  }
}
linhas <- do.call(what = 'rbind',args = linhas)


producaoBENEFICIADA <-
  producaoBENEFICIADA[-linhas, ]















# CARREGANDO Produ??o QUANTIDADE_E_VALOR_DA_PRODU??O_COMERCIALIZADA ----

VPM_QuantidadeValorCOMERCIALIZADO <-
  read.table(
    "D:/Users/humberto.serna/Documents/D_Lake/DBAMB_QuantidadeEhValordaProducaoMineralComercializada.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = ""
  )


colnames(VPM_QuantidadeValorCOMERCIALIZADO) <-
  colnames(VPM_QuantidadeValorCOMERCIALIZADO) %>% FUNA_removeAcentos()
colnames(VPM_QuantidadeValorCOMERCIALIZADO) <-
  c("Ano", "CPFCNPJ", "unidade", "Titular", 
    "tipo", "Municipio", "uf", "substancia.amb", "Substancia.RAL", "produto", 
    "Quantidade.Producao.Comercializada.Substancia", "Valor.Producao.Comercializada.Substancia.AMB", 
    "Quantidade.Producao.Comercializada.Produto", "Valor.Producao.Comercializada.Produto"
  ) %>% FUNA_minusculas()


VPM_QuantidadeValorCOMERCIALIZADO$substancia.ral <- 
  VPM_QuantidadeValorCOMERCIALIZADO$substancia.ral %>% FUNA_removeAcentos()

VPM_QuantidadeValorCOMERCIALIZADO$municipio <-
  VPM_QuantidadeValorCOMERCIALIZADO$municipio %>% FUNA_removeAcentos() %>% FUNA_minusculas()

VPM_QuantidadeValorCOMERCIALIZADO$titular <-
  VPM_QuantidadeValorCOMERCIALIZADO$titular %>% FUNA_removeAcentos() %>% FUNA_minusculas()

VPM_QuantidadeValorCOMERCIALIZADO$substancia.amb <-
  VPM_QuantidadeValorCOMERCIALIZADO$substancia.amb %>% FUNA_removeAcentos() %>% FUNA_minusculas()

VPM_QuantidadeValorCOMERCIALIZADO$produto <-
  VPM_QuantidadeValorCOMERCIALIZADO$produto %>% FUNA_removeAcentos() %>% FUNA_minusculas()

VPM_QuantidadeValorCOMERCIALIZADO$tipo <-
  VPM_QuantidadeValorCOMERCIALIZADO$tipo %>% FUNA_removeAcentos() %>% FUNA_minusculas()





# CARREGANDO consumidores MINA ----

consumidoresMINA <-
  read.table(
    file = "D:/Users/humberto.serna/Documents/D_Lake/DBAMB_PrincipaisCompradoresMina.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = ""
  )



colnames(consumidoresMINA) <-
  colnames(consumidoresMINA) %>% FUNA_removeAcentos() 
colnames(consumidoresMINA) <-
  c(
    "ano",
    "titular",
    "cpfcnpj",
    "mina",
    "municipio",
    "uf",
    "substancias.amb.mina",
    "minerio",
    "nome.comprador",
    "uso.destinacao",
    "municipio.comprador",
    "uf.comprador",
    "quantidade.compra",
    "valor.compra"
  ) %>% FUNA_minusculas()


consumidoresMINA$municipio <-
  consumidoresMINA$municipio %>% FUNA_removeAcentos() %>% FUNA_minusculas()

consumidoresMINA$titular <-
  consumidoresMINA$titular %>% FUNA_removeAcentos() %>% FUNA_minusculas()

consumidoresMINA$substancias.amb.mina <-
  consumidoresMINA$substancias.amb.mina %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()

consumidoresMINA$minerio <-
  consumidoresMINA$minerio %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()

consumidoresMINA$mina <-
  consumidoresMINA$mina %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()

consumidoresMINA$preco <-
  round(consumidoresMINA$valor.compra / consumidoresMINA$quantidade.compra,
        digits = 1)


# CARREGANDO consumidores USINA ----

consumidoresUSINA <-
  read.table(
    file = "D:/Users/humberto.serna/Documents/D_Lake/DBAMB_PrincipaisCompradoresUsina.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = ""
    )

colnames(consumidoresUSINA) <-
  colnames(consumidoresUSINA) %>% FUNA_removeAcentos()
colnames(consumidoresUSINA) <-
  c(
    "ano",
    "titular",
    "cpfcnpj",
    "usina",
    "municipio",
    "uf",
    "produto.beneficiado",
    "substancias.amb.usina",
    "nome.comprador",
    "uso.destinacao",
    "quantidade.compra",
    "valor.compra"
  ) %>% FUNA_minusculas()


consumidoresUSINA$municipio <-
  consumidoresUSINA$municipio %>% FUNA_removeAcentos() %>% FUNA_minusculas()


consumidoresUSINA$titular <-
  consumidoresUSINA$titular %>% FUNA_removeAcentos() %>% FUNA_minusculas()

consumidoresUSINA$substancias.amb.usina <-
  consumidoresUSINA$substancias.amb.usina %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()

consumidoresUSINA$usina <-
  consumidoresUSINA$usina %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()

consumidoresUSINA$produto.beneficiado <-
  consumidoresUSINA$produto.beneficiado %>% FUNA_removeAcentos() %>% FUNA_minusculas() %>% stringr::str_squish()

consumidoresUSINA$preco <- round(
  consumidoresUSINA$valor.compra / consumidoresUSINA$quantidade.compra,
  digits = 1
)


# CARREGANDO eventos RFP_RRR ----

Eventos_RRR_RFP <-
  read.table(
    file = "D:/Users/humberto.serna/Documents/D_Lake/DBAMB_Reserva_Eventos_RRR_RFP.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = ""
  )


colnames(Eventos_RRR_RFP) <- 
  c("ano", "cpfcnpj", "processo", "substancia.amb", "reavaliacao.reserva", 
    "situacao.operacional.processo", "motivo.situacao.processo")

# CARREGANDO Informacoes Complementares ----

InformacoesComplementares <-
  read.table(
    file = "D:/Users/humberto.serna/Documents/D_Lake/DBAMB_InformacoesComplementares.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = ""
  )



colnames(InformacoesComplementares) <- 
  c("ano", "processo", "cpfcnpj", "informacoes_Complementares", 
    "data_Motivo_Situacao_Processo", "motivo_Processo",
    "situacao_Operacional_Processo")




InformacoesComplementares <-
  InformacoesComplementares[, c(
    "ano","processo","cpfcnpj",
    "data_Motivo_Situacao_Processo",
    "motivo_Processo",
    "situacao_Operacional_Processo",
    "informacoes_Complementares"
  )]



# CARREGANDO GEOCOD ----

geocod <-
  read.table(
    file = "D:/Users/humberto.serna/Documents/D_Lake/geocod.csv",
    header = TRUE,
    sep = ";",
    dec = ",",
    stringsAsFactors = FALSE,
    encoding = 'latin1',
    fill = TRUE,
    quote = ""
  )


geocod$NM_MUNICIP_STRING <- 
  geocod$NM_MUNICIP_STRING %>% FUNA_removeAcentos() %>% FUNA_minusculas()

geocod <- geocod[,c(1,2)]
colnames(geocod) <- c("municipio", "geocod")



