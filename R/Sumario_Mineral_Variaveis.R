
# RESET
rm(A, B, C, ContidoMedido, ContidoMedido_Ano_Anterior, ContidoMedido_MUN, ContidoMedido_UF, escala_ContidoMedido, escala_ContidoMedido_Ano_Anterior, escala_ContidoMedido_MUN, escala_ContidoMedido_UF, escala_ProducaoBENEFICIADA, escala_ProducaoBENEFICIADA_ANO, escala_ProducaoBENEFICIADA_UF, escala_ProducaoCONTIDO, escala_ProducaoCONTIDO_ANO, escala_ProducaoCONTIDO_UF, escala_ReservaMedida, escala_ReservaMedida_Ano_Anterior, escala_ReservaMedida_MUN, escala_ReservaMedida_UF, Fator_Agregado_EXPORTACAO, Fator_Agregado_IMPORTACAO, Producao_Mundial, Producao_Mundial_Ano_Anterior, Producao_PAIS, Producao_Reserva_PAIS, Producao_WMD, ProducaoBENEFICIADA, ProducaoBENEFICIADA_ANO, ProducaoBENEFICIADA_UF, ProducaoCONTIDO, ProducaoCONTIDO_ANO, ProducaoCONTIDO_UF, Reserva_Mundial, Reserva_PAIS, Reserva_WMD, ReservaMedida, ReservaMedida_Ano_Anterior, ReservaMedida_MUN, ReservaMedida_UF, SaldoComex, SharePaisExportacao1, SharePaisExportacao2, SharePaisExportacao3, SharePaisImportacao1, SharePaisImportacao2, SharePaisImportacao3, SimboloQuimico, thousandMT_Prod, Top3_NCM_EX, Top3_NCM_IMP, Top3_PaisEX, Top3_PaisIMP, unidade, unidade_ProducaoBENEFICIADA, ValorExportado, ValorImportado, VariacaoContidoMedido, VariacaoMundial, VariacaoProducaoBENEFICIADA, VariacaoProducaoCONTIDO, VariacaoReservaMedida, VariacaoSaldoComex, VariacaoValorExportado, VariacaoValorImportado)

# _____ DADOS INTERNACIONAIS ----  

# __________ Producao Mundial ----


# "(...) thousand metric tons (...)". Se o líder produz mais que 1000 t, ajustar a escala para 10³
Producao_WMD <-
  arrange(filter(WMD, substancia.agrupadora == SUBS, Country != "Total"),
          desc(Produção))

if (Producao_WMD[Producao_WMD$Ano == ANO,][3, "Produção"] > 10000) {
  
  Producao_WMD$Produção <- Producao_WMD$Produção / 1000
  
  thousandMT_Prod <- 1
    
  } else {
    thousandMT_Prod <- 0
  }


Producao_Mundial <- 
    sum(Producao_WMD[Producao_WMD$substancia.agrupadora == SUBS & 
              Producao_WMD$Ano == ANO,]$Produção)

Producao_Mundial_Ano_Anterior <-
    sum(Producao_WMD[Producao_WMD$substancia.agrupadora == SUBS & 
              Producao_WMD$Ano == ANO-1,]$Produção)

# __________ Producao por País ----

Producao_PAIS <-
    arrange(
      spread(
        Producao_WMD[Producao_WMD$substancia.agrupadora == SUBS & 
              Producao_WMD$Ano %in% c(ANO, ANO-1, ANO-2),],
        key = Ano, value = Produção), desc(`2018`))[c(1:6),]


# __________ Variacao Mundial ----

VariacaoMundial <-
  100* (Producao_Mundial - 
       sum(Producao_WMD[Producao_WMD$substancia.agrupadora == SUBS & 
                 Producao_WMD$Ano == ANO-1,]$Produção, na.rm = T))/
      sum(Producao_WMD[Producao_WMD$substancia.agrupadora == SUBS & 
                         Producao_WMD$Ano == ANO-1,]$Produção, na.rm = T)


# __________ Reservas Internacionais  ----



# "(...) thousand metric tons (...)". Se o líder produz mais que 1000 t, ajustar a escala para 10³
Reserva_WMD <-
  arrange(filter(reservas_USGS, substancia.agrupadora == SUBS),
          desc(reserva))




if (thousandMT_Prod == 1) {
  
  Reserva_WMD$reserva <- Reserva_WMD$reserva / 1000
  
}


Reserva_PAIS <-
  na.omit(
    # head(
    arrange(Reserva_WMD[Reserva_WMD$substancia.agrupadora == SUBS & 
                          Reserva_WMD$pais != "World total (rounded)" & 
                          Reserva_WMD$pais != "Other countries", ],
            desc(reserva)))
    # ,6))


# ____________ Quadro Produção-Reserva Países  ----

Producao_Reserva_PAIS <-
  head(arrange(left_join(
    Producao_PAIS, Reserva_PAIS, by = c("Country" = "Português")
  ),
  desc('2018')), 6)

  
# Reserva_Mundial
  
  
  if (Reserva_WMD[Reserva_WMD$substancia.agrupadora == SUBS &
                    grepl(Reserva_WMD$pais, pattern = "World"),]$pais == "World total (rounded)") {
    
    Reserva_Mundial <- 
      Reserva_WMD[Reserva_WMD$substancia.agrupadora == SUBS &
                    Reserva_WMD$pais == "World total (rounded)",]$reserva
    
  } else if (Reserva_WMD[Reserva_WMD$substancia.agrupadora == SUBS &
                           grepl(Reserva_WMD$pais, pattern = "World"),]$pais == "World total (large)") {
      
    Reserva_Mundial <- "large"
      
    
  } else { 
    
    Reserva_Mundial <-
        Reserva_WMD[
          Reserva_WMD$substancia.agrupadora == SUBS &
            Reserva_WMD$pais == "World total (above)",]$reserva
      
    }
  


# _____ RESERVA NACIONAL -----

if (SUBS == "Titânio") {
  RESERVAS_NACIONAIS <-
    reserva_AMB[reserva_AMB$substancia.agrupadora == SUBS &
                  reserva_AMB$substancia.amb != "Anatásio", ]
  
} else if (SUBS == "Monazita e Terras-Raras") {
  RESERVAS_NACIONAIS <-
    reserva_AMB[reserva_AMB$substancia.agrupadora == SUBS &
                  reserva_AMB$substancia.amb != "Monazita", ]
  
} else if (SUBS == "Dolomito e Magnesita") {
  RESERVAS_NACIONAIS <-
    reserva_AMB[reserva_AMB$substancia.agrupadora == SUBS &
                  reserva_AMB$substancia.amb != "Dolomito", ]
  
} else {
  RESERVAS_NACIONAIS <-
    reserva_AMB[reserva_AMB$substancia.agrupadora == SUBS,]
}



# __________  Reserva Medida ----

  if (sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO,]$massa.medida) > 10000000) {

    ReservaMedida <-
      sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO,]$massa.medida) / 1000000
    
    escala_ReservaMedida <- "milhões"
    
  } else if (sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                    RESERVAS_NACIONAIS$ano == ANO,]$massa.medida) > 100000) {
    
    ReservaMedida <-
      sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO,]$massa.medida) / 1000
    
    escala_ReservaMedida <- "mil"    
    
  } else {
    
    ReservaMedida <-
      sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO,]$massa.medida)
    
    escala_ReservaMedida <- ""    
  }



# __________  ReservaMedida_Ano_Anterior ----

if (sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                           RESERVAS_NACIONAIS$ano == ANO - 1, ]$massa.medida) > 10000000) {
  ReservaMedida_Ano_Anterior <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO - 1, ]$massa.medida) / 1000000
  
  escala_ReservaMedida_Ano_Anterior <- "milhões"
  
} else if (sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                  RESERVAS_NACIONAIS$ano == ANO - 1, ]$massa.medida) > 100000) {
  ReservaMedida_Ano_Anterior <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO - 1, ]$massa.medida) / 1000
  
  escala_ReservaMedida_Ano_Anterior <- "mil"
  
} else {
  ReservaMedida_Ano_Anterior <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO - 1, ]$massa.medida)
  
  escala_ReservaMedida_Ano_Anterior <- "t"
}



# __________  Variacao Reserva Medida ----
VariacaoReservaMedida <-
  100 * ((
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                      RESERVAS_NACIONAIS$ano == ANO,]$massa.medida
    ) - sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                          RESERVAS_NACIONAIS$ano == ANO - 1,]$massa.medida)
  ) / sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                        RESERVAS_NACIONAIS$ano == ANO - 1,]$massa.medida))

#__________ Reserva_Medida_UF ----

ReservaMedida_UF <-
  as.data.frame(
  arrange(
    summarise(
      group_by(
        RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                      RESERVAS_NACIONAIS$ano == ANO,], uf),
      "massa.medida" = sum(massa.medida)), desc(massa.medida)))




if (ReservaMedida_UF[1, "massa.medida"] > 100000) {
  
  ReservaMedida_UF$massa.medida <- ReservaMedida_UF$massa.medida / 1000
  
  escala_ReservaMedida_UF <- "mil"
  
} else {
  escala_ReservaMedida_UF <- ""
}




#__________ Reserva_Medida_Município ----

ReservaMedida_MUN <-
  as.data.frame(
  arrange(
    summarise(
      group_by(
        RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                      RESERVAS_NACIONAIS$ano == ANO,], municipio),
      "massa.medida" = sum(massa.medida)), desc(massa.medida)))


if (ReservaMedida_MUN[1, "massa.medida"] > 100000) {
  
  ReservaMedida_MUN$massa.medida <- ReservaMedida_MUN$massa.medida / 1000
  
  escala_ReservaMedida_MUN <- "mil"
  
} else {
  escala_ReservaMedida_MUN <- ""
}


# __________  Contido Medido ----

if (sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                           RESERVAS_NACIONAIS$ano == ANO,]$contido.medido) > 10000000) {
  
  ContidoMedido <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO,]$contido.medido) / 1000000
  
  escala_ContidoMedido <- "milhões"
  
} else if (sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                  RESERVAS_NACIONAIS$ano == ANO,]$contido.medido) > 100000) {
  
  ContidoMedido <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO,]$contido.medido) / 1000
  
  escala_ContidoMedido <- "mil"    
  
} else {
  
  ContidoMedido <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO,]$contido.medido)
  
  escala_ContidoMedido <- ""    
}



# __________  ContidoMedido_Ano_Anterior ----

if (sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                           RESERVAS_NACIONAIS$ano == ANO - 1, ]$contido.medido) > 10000000) {
  ContidoMedido_Ano_Anterior <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO - 1, ]$contido.medido) / 1000000
  
  escala_ContidoMedido_Ano_Anterior <- "milhões"
  
} else if (sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                  RESERVAS_NACIONAIS$ano == ANO - 1, ]$contido.medido) > 100000) {
  ContidoMedido_Ano_Anterior <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO - 1, ]$contido.medido) / 1000
  
  escala_ContidoMedido_Ano_Anterior <- "mil"
  
} else {
  ContidoMedido_Ano_Anterior <-
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                   RESERVAS_NACIONAIS$ano == ANO - 1, ]$contido.medido)
  
  escala_ContidoMedido_Ano_Anterior <- ""
}



# __________  Variacao Contido Medido ----
VariacaoContidoMedido <-
  100 * ((
    sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                             RESERVAS_NACIONAIS$ano == ANO,]$contido.medido
    ) - sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                                 RESERVAS_NACIONAIS$ano == ANO - 1,]$contido.medido)
  ) / sum(RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                               RESERVAS_NACIONAIS$ano == ANO - 1,]$contido.medido))

#__________ Contido_Medido_UF ----

ContidoMedido_UF <-
  as.data.frame(
  arrange(
    summarise(
      group_by(
        RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                             RESERVAS_NACIONAIS$ano == ANO,], uf),
      "contido.medido" = sum(contido.medido)), desc(contido.medido)))




if (ContidoMedido_UF[1, "contido.medido"] > 100000) {
  
  ContidoMedido_UF$contido.medido <- ContidoMedido_UF$contido.medido / 1000
  
  escala_ContidoMedido_UF <- "mil"
  
} else {
  escala_ContidoMedido_UF <- ""
}


#__________ Contido_Medido_Município ----
ContidoMedido_MUN <-
  as.data.frame(
  arrange(
    summarise(
      group_by(
        RESERVAS_NACIONAIS[RESERVAS_NACIONAIS$substancia.agrupadora == SUBS &
                             RESERVAS_NACIONAIS$ano == ANO,], municipio),
      "contido.medido" = sum(contido.medido)), desc(contido.medido)))


if (ContidoMedido_MUN[1, "contido.medido"] > 100000) {
  
  ContidoMedido_MUN$contido.medido <- ContidoMedido_MUN$contido.medido / 1000
  
  escala_ContidoMedido_MUN <- "mil"
  
} else {
  escala_ContidoMedido_MUN <- ""
}




# _____ PRODUÇÃO NACIONAL ----


# __________  Producao BENEFICIADA ----
ProducaoBENEFICIADA <-
  sum(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                               producaoBENEFICIADA$ano == ANO, ]$quantidade.producao / 1000)


escala_ProducaoBENEFICIADA <- "mil"


# __________  Variacao Producao BENEFICIADA ----
VariacaoProducaoBENEFICIADA <-
  100 * ((
    sum(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                              producaoBENEFICIADA$ano == ANO,]$quantidade.producao / 1000) -
      sum(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                                producaoBENEFICIADA$ano == ANO - 1,]$quantidade.producao / 1000)
  ) /
    sum(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                              producaoBENEFICIADA$ano == ANO - 1,]$quantidade.producao / 1000)
  )


# __________  Producao BENEFICIADA_UF ----

ProducaoBENEFICIADA_UF <-
  as.data.frame(
  arrange(summarise(
    group_by(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS, ], uf),
    "producaoUF" = round(
      sum(quantidade.producao),
      digits = 1
    )
  ), desc(producaoUF)))

escala_ProducaoBENEFICIADA_UF <- ""

ProducaoBENEFICIADA_UF$participacao <- 
  100 * 
  (ProducaoBENEFICIADA_UF$producaoUF/sum(ProducaoBENEFICIADA_UF$producaoUF))





# __________  Producao BENEFICIADA_ANO ----

ProducaoBENEFICIADA_ANO <-
  head(arrange(summarise(
    group_by(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                                   producaoBENEFICIADA$ano < c(ANO +
                                                                 1), ], ano),
    "producaoANO" = (sum(quantidade.producao))
  ),
  desc(ano)), 3)


escala_ProducaoBENEFICIADA_ANO <- ""


# __________  Producao CONTIDO ----
ProducaoCONTIDO <-
  sum(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                               producaoBENEFICIADA$ano == ANO, ]$quantidade.contido
    ) / 1000

escala_ProducaoCONTIDO <- "mil"

# __________  Producao CONTIDO UF ----
ProducaoCONTIDO_UF <- 
  arrange(
    summarise(
      group_by(
        producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS,], uf), 
                    "producaoUF" = round(sum(quantidade.contido), digits = 1)),
    desc(producaoUF))

escala_ProducaoCONTIDO_UF <- ""


ProducaoCONTIDO_UF$participacao <- 
  100 * 
  (ProducaoCONTIDO_UF$producaoUF/sum(ProducaoCONTIDO_UF$producaoUF))


# __________  Producao CONTIDO_ANO ----

ProducaoCONTIDO_ANO <- 
  head(arrange(
    summarise(group_by(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS & 
                                              producaoBENEFICIADA$ano < c(ANO+1), ], ano), 
              "producaoANO" = (sum(quantidade.contido)
                              )), desc(ano)),3)

escala_ProducaoCONTIDO_ANO <- ""


# __________  Variacao Producao CONTIDO ----
VariacaoProducaoCONTIDO <-
  100 * ((sum(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                                           producaoBENEFICIADA$ano == ANO,]$quantidade.contido
  ) - sum(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                                 producaoBENEFICIADA$ano == ANO - 1,]$quantidade.contido
  )) / sum(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS &
                                  producaoBENEFICIADA$ano == ANO - 1,]$quantidade.contido))


# __________  Unidade Produção Beneficiada ----

unidade_ProducaoBENEFICIADA <- 
  unique(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS,]$unidade.de.medida.producao)

# __________  Simbolo Quimico ----
SimboloQuimico <-
  str_trim(
    unique(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS, ]$indicacao.contido))

# __________  unidade Contido ----
unidade <-
  unique(producaoBENEFICIADA[producaoBENEFICIADA$substancia == SUBS, ]$unidade.contido)


# _____  COMEX ----


# __________ Saldo Comex ----
SaldoComex <- 
  Saldo_da_Balança_de_Bens[Saldo_da_Balança_de_Bens$SUBSTANCIA == SUBS & 
                             Saldo_da_Balança_de_Bens$CO_ANO == ANO,]$SALDO

# __________ Variacao SaldoComex ----
VariacaoSaldoComex <- 
  100 * ((
    sum(Saldo_da_Balança_de_Bens[Saldo_da_Balança_de_Bens$SUBSTANCIA == SUBS &
                                   Saldo_da_Balança_de_Bens$CO_ANO == ANO,]$SALDO
    ) - sum(Saldo_da_Balança_de_Bens[Saldo_da_Balança_de_Bens$SUBSTANCIA == SUBS &
                                       Saldo_da_Balança_de_Bens$CO_ANO == ANO - 1,]$SALDO)
  ) / sum(Saldo_da_Balança_de_Bens[Saldo_da_Balança_de_Bens$SUBSTANCIA == SUBS &
                                     Saldo_da_Balança_de_Bens$CO_ANO == ANO - 1,]$SALDO))
# __________ Valor Exportado ----
ValorExportado <- 
  Saldo_da_Balança_de_Bens[Exportacoes_Totais$SUBSTANCIA == SUBS & 
                             Exportacoes_Totais$CO_ANO == ANO,]$EX_FOB

# __________ Variacao Valor Exportado ----
VariacaoValorExportado <- 
  100 * ((
    sum(Exportacoes_Totais[Exportacoes_Totais$SUBSTANCIA == SUBS &
                             Exportacoes_Totais$CO_ANO == ANO,]$EX_FOB
    ) - sum(Exportacoes_Totais[Exportacoes_Totais$SUBSTANCIA == SUBS &
                                 Exportacoes_Totais$CO_ANO == ANO - 1,]$EX_FOB)
  ) / sum(Exportacoes_Totais[Exportacoes_Totais$SUBSTANCIA == SUBS &
                               Exportacoes_Totais$CO_ANO == ANO - 1,]$EX_FOB))

# __________ Exportacao_Pais ----
Top3_PaisEX <-
  head(
    arrange(Exportacoes_Totais_Paises[Exportacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                        Exportacoes_Totais_Paises$CO_ANO == ANO, ], 
            desc(EX_FOB.x)), n = 3)[, c("NO_PAIS")]

SharePaisExportacao1 <-  
  round(100 * (
    Exportacoes_Totais_Paises[Exportacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                Exportacoes_Totais_Paises$CO_ANO == ANO &
                                Exportacoes_Totais_Paises$NO_PAIS == Top3_PaisEX[1],]$EX_FOB.x
    / sum(Exportacoes_Totais_Paises[Exportacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                      Exportacoes_Totais_Paises$CO_ANO == ANO,]$EX_FOB.x)), digits = 1)
SharePaisExportacao2 <-  
  round(100 * (
    Exportacoes_Totais_Paises[Exportacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                Exportacoes_Totais_Paises$CO_ANO == ANO &
                                Exportacoes_Totais_Paises$NO_PAIS == Top3_PaisEX[2],]$EX_FOB.x
    / sum(Exportacoes_Totais_Paises[Exportacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                      Exportacoes_Totais_Paises$CO_ANO == ANO,]$EX_FOB.x)), digits = 1)

SharePaisExportacao3 <-  
  round(100 * (
    Exportacoes_Totais_Paises[Exportacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                Exportacoes_Totais_Paises$CO_ANO == ANO &
                                Exportacoes_Totais_Paises$NO_PAIS == Top3_PaisEX[3],]$EX_FOB.x
    / sum(Exportacoes_Totais_Paises[Exportacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                      Exportacoes_Totais_Paises$CO_ANO == ANO,]$EX_FOB.x)), digits = 1)


# __________ Valor Importado ----
ValorImportado <- 
  Importacoes_Totais[Importacoes_Totais$SUBSTANCIA == SUBS & 
                       Importacoes_Totais$CO_ANO == ANO,]$IMP_FOB


# __________ Variacao Valor Importado ----
VariacaoValorImportado <- 
  100 * ((
    sum(Importacoes_Totais[Importacoes_Totais$SUBSTANCIA == SUBS &
                             Importacoes_Totais$CO_ANO == ANO,]$IMP_FOB
    ) - sum(Importacoes_Totais[Importacoes_Totais$SUBSTANCIA == SUBS &
                                 Importacoes_Totais$CO_ANO == ANO - 1,]$IMP_FOB)
  ) / sum(Importacoes_Totais[Importacoes_Totais$SUBSTANCIA == SUBS &
                               Importacoes_Totais$CO_ANO == ANO - 1,]$IMP_FOB))


# __________ Top3_Pais IMP ----
Top3_PaisIMP <-
  head(
    arrange(Importacoes_Totais_Paises[Importacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                        Importacoes_Totais_Paises$CO_ANO == ANO, ], 
            desc(IMP_FOB.x)), n = 3)[, c("NO_PAIS")]

SharePaisImportacao1 <-  
  round(100 * (
    Importacoes_Totais_Paises[Importacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                Importacoes_Totais_Paises$CO_ANO == ANO &
                                Importacoes_Totais_Paises$NO_PAIS == Top3_PaisIMP[1],]$IMP_FOB.x
     / sum(Importacoes_Totais_Paises[Importacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                  Importacoes_Totais_Paises$CO_ANO == ANO,]$IMP_FOB.x)), digits = 1)
SharePaisImportacao2 <-  
  round(100 * (
    Importacoes_Totais_Paises[Importacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                Importacoes_Totais_Paises$CO_ANO == ANO &
                                Importacoes_Totais_Paises$NO_PAIS == Top3_PaisIMP[2],]$IMP_FOB.x
    / sum(Importacoes_Totais_Paises[Importacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                      Importacoes_Totais_Paises$CO_ANO == ANO,]$IMP_FOB.x)), digits = 1)

SharePaisImportacao3 <-  
  round(100 * (
    Importacoes_Totais_Paises[Importacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                Importacoes_Totais_Paises$CO_ANO == ANO &
                                Importacoes_Totais_Paises$NO_PAIS == Top3_PaisIMP[3],]$IMP_FOB.x
    / sum(Importacoes_Totais_Paises[Importacoes_Totais_Paises$SUBSTANCIA == SUBS &
                                      Importacoes_Totais_Paises$CO_ANO == ANO,]$IMP_FOB.x)), digits = 1)

# __________ Top3_NCM_EX ----
Top3_NCM_EX <-
  head(
    arrange(Exportacoes_por_NCM[Exportacoes_por_NCM$SUBSTANCIA == SUBS &
                                  Exportacoes_por_NCM$CO_ANO == ANO, ], 
            desc(EX_FOB.x)), n = 3)[, c("NO_NCM_Subitem_POR", "CO_NCM", 'percentual_Produto_NCM')]

Top3_NCM_IMP <-
  head(
    arrange(Importacoes_por_NCM[Importacoes_por_NCM$SUBSTANCIA == SUBS &
                                  Importacoes_por_NCM$CO_ANO == ANO, ], 
            desc(IMP_FOB.x)), n = 3)[, c("NO_NCM_Subitem_POR", "CO_NCM", 'percentual_Produto_NCM')]

# __________ Preco_Comex ----

# *********************************** ARRUMAR ncm_comex para constar 3 anos

Preco_Comex <- 
  rbind(
    head(
      arrange(Preco_Exportacao[Preco_Exportacao$SUBSTANCIA == SUBS &
                                 Preco_Exportacao$CO_ANO %in% c(ANO, ANO-1, ANO-2),], 
              desc(VALOR_.usd.un.)), n = 1)[, c("NO_NCM_Subitem_POR", "CO_NCM", 'SG_UNID','VALOR_.usd.un.')],
    head(
      arrange(Preco_Importacao[Preco_Importacao$SUBSTANCIA == SUBS &
                                 Preco_Importacao$CO_ANO %in% c(ANO, ANO-1, ANO-2),], 
              desc(VALOR_.usd.un.)), n = 1)[, c("NO_NCM_Subitem_POR", "CO_NCM", 'SG_UNID','VALOR_.usd.un.')])



# __________ Fator Agregado ----

Fator_Agregado_EXPORTACAO <-
  Exportacao_Fator_Agregacao[Exportacao_Fator_Agregacao$SUBSTANCIA == SUBS &
                               Exportacao_Fator_Agregacao$CO_ANO == ANO, c("NO_FAT_AGREG", "percentual_FAT_AGREG")]

Fator_Agregado_IMPORTACAO <-
  Importacao_Fator_Agregacao[Importacao_Fator_Agregacao$SUBSTANCIA == SUBS &
                               Importacao_Fator_Agregacao$CO_ANO == ANO, c("NO_FAT_AGREG", "percentual_FAT_AGREG")]



# APÊNDICE ----
# Escalas

metadados[SUBS, "SUBS"] <- SUBS

metadados[SUBS, "unidade_ProducaoBENEFICIADA"] <- unidade_ProducaoBENEFICIADA
metadados[SUBS, "escala_ProducaoBENEFICIADA"] <- escala_ProducaoBENEFICIADA
metadados[SUBS, "escala_ProducaoBENEFICIADA_ANO"] <- escala_ProducaoBENEFICIADA_ANO
metadados[SUBS, "escala_ProducaoBENEFICIADA_UF"] <- escala_ProducaoBENEFICIADA_UF

metadados[SUBS, "escala_ProducaoCONTIDO"] <- escala_ProducaoCONTIDO
metadados[SUBS, "escala_ProducaoCONTIDO_ANO"] <- escala_ProducaoCONTIDO_ANO
metadados[SUBS, "escala_ProducaoCONTIDO_UF"] <- escala_ProducaoCONTIDO_UF
metadados[SUBS, "unidade"] <- unidade[1]
metadados[SUBS, "thousandMT_Prod"] <- thousandMT_Prod

metadados[SUBS, "escala_ContidoMedido"] <- escala_ContidoMedido
metadados[SUBS, "escala_ContidoMedido_Ano_Anterior"] <- escala_ContidoMedido_Ano_Anterior
metadados[SUBS, "escala_ContidoMedido_MUN"] <- escala_ContidoMedido_MUN
metadados[SUBS, "escala_ContidoMedido_UF"] <- escala_ContidoMedido_UF

metadados[SUBS, "escala_ReservaMedida"] <- escala_ReservaMedida
metadados[SUBS, "escala_ReservaMedida_Ano_Anterior"] <- escala_ReservaMedida_Ano_Anterior
metadados[SUBS, "escala_ReservaMedida_MUN"] <- escala_ReservaMedida_MUN
metadados[SUBS, "escala_ReservaMedida_UF"] <- escala_ReservaMedida_UF
