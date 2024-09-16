


#     USGS_summaries <- "D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown/USGS_mcs_2020_all.pdf"
#     substancia <- list("Alumínio","Bauxita.e.Alumina","Bentonita.E.Caulim","Cobalto","Cobre","Ouro","Grafita","Ferro.e.aço","Minério.de.ferro","Chumbo","Cal","Lítio","Magnesita","Manganês","Níquel","Nióbio","Rocha.Fosfatica","Potássio","Terras.raras","Prata","Tântalo","Estanho","Titânio.e.dióxido.de.titânio","Concentrados.Minerais.de.Titânio","Tungstênio","Vanádio","Zinco","Zircônio.e.háfnio")
#     pagina <- list("25","35","53","55","57","75","77","87","93","99","101","103","107","109","117","119","127","131","137","155","169","177","179","181","183","185","195","197")
#     USGS_tabelas_2 <- list()
#     USGS_tabelas_3 <- list()
#     USGS_tabelas_4 <- list()
#     USGS_tabelas_5 <- list()
#     USGS_tabelas_6 <- list()
#     USGS_tabelas_7 <- list()
#     USGS_tabelas_8 <- list()
#     USGS_tabelas_9 <- list()
#     USGS_tabelas_10 <- list()
#     
#     for (i in 1:length(substancia)) {
#       
#       df <-
#         data.frame(tabulizer::extract_tables(file = USGS_summaries, pages = c(pagina[i])))
#       df$substancia <- substancia[i]
#       
#       if (length(df) == 2) {
#         USGS_tabelas_2[[i]] <- df
#       } else if (length(df) == 3) {
#         USGS_tabelas_3[[i]] <- df
#       } else if (length(df) == 4) {
#         USGS_tabelas_4[[i]] <- df
#       } else if (length(df) == 5) {
#         USGS_tabelas_5[[i]] <- df
#       } else if (length(df) == 6) {
#         USGS_tabelas_6[[i]] <- df
#       } else if (length(df) == 7) {
#         USGS_tabelas_7[[i]] <- df
#       } else if (length(df) == 8) {
#         USGS_tabelas_8[[i]] <- df
#       } else if (length(df) == 9) {
#         USGS_tabelas_9[[i]] <- df
#       } else { 
#         USGS_tabelas_10[[i]] <- df
#       }
#     }
#     
#   
#     colnames(USGS_tabelas_2[[9]]) <- c("X1","X2")
#     colnames(USGS_tabelas_2[[18]]) <- c("X1","X2")
#     
#     
#     USGS_2 <- do.call('rbind', USGS_tabelas_2)
#     USGS_3 <- do.call('rbind', USGS_tabelas_3)
#     USGS_4 <- do.call('rbind', USGS_tabelas_4)
#     USGS_5 <- do.call('rbind', USGS_tabelas_5)
#     USGS_6 <- do.call('rbind', USGS_tabelas_6)
#     USGS_7 <- do.call('rbind', USGS_tabelas_7)
#     USGS_8 <- do.call('rbind', USGS_tabelas_8)
#     USGS_9 <- do.call('rbind', USGS_tabelas_9)
#     USGS_10 <- do.call('rbind', USGS_tabelas_10)
#     
#  # USGS_2  ----
#     df <- USGS_2  
#     
#     df$pais <- 
#       gsub(df[,1], pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#       gsub(df[,1], pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#       gsub(df[,1], pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% str_trim()
#     df$pais <- gsub(df$pais, pattern = "[0-9]|[-]|[,]", replacement = "") %>% str_trim()
#     df$numeros <- 
#       gsub(df[,1], pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#       gsub(df[,1], pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#       gsub(df[,1], pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>%
#       gsub(df[,1], pattern = "[a-z]|[A-Z]|[()]", replacement = "") %>% 
#       gsub(df[,1], pattern = "1000001", replacement = "NA") %>% str_trim()
#     
#     df <- 
#      separate(
#        df, col = "numeros", into = c("2018","2019","reserva"),sep = " ") # %>% View()
#     
#      df_USGS <- 
#        df[,-1]
#  
#      df_USGS <- df_USGS[,c("substancia", "pais", "reserva")]
#    
#      df_USGS$reserva <- 
#        as.numeric(
#          gsub(df_USGS$reserva, pattern = ",", replacement = ""))
#      
#  # USGS_4  ----
#      df <- USGS_4  
#      
#      df$pais <- 
#        gsub(df$X1, pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#        gsub(df$X1, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#        gsub(df$X1, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% str_trim()
#      df$pais <- gsub(df$pais, pattern = "[0-9]|[-]|[,]", replacement = "") %>% str_trim()
#      df$numeros_a <- 
#        gsub(df$X2, pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#        gsub(df$X2, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#        gsub(df$X2, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>%
#        gsub(df$X2, pattern = "[a-z]|[A-Z]|[()]", replacement = "") %>% 
#        gsub(df$X2, pattern = "1000001", replacement = "NA") %>% str_trim()
#      
#      
#      df$numeros_b <- 
#        gsub(df$X3, pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#        gsub(df$X3, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#        gsub(df$X3, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>%
#        gsub(df$X3, pattern = "[a-z]|[A-Z]|[()]", replacement = "") %>% 
#        gsub(df$X3, pattern = "1000001", replacement = "NA") %>% str_trim()
#      
#      
#      df <- 
#        separate(
#          df, col = "numeros_a", into = c("a1","a2","a3",'a4',"a5","a6"),sep = " ") #  %>% View()
#      
#      df <- 
#        separate(
#          df, col = "numeros_b", into = c("b1","b2","b3",'b4',"b5",'b6'),sep = " ") #  %>% View()
#      
#      
#      df$a1 <- 
#        as.numeric(gsub(df$a1, pattern = ",", replacement = ""))
#      
#      df$a2 <- 
#        as.numeric(gsub(df$a2, pattern = ",", replacement = ""))
#      
#      df$a3 <- 
#        as.numeric(gsub(df$a3, pattern = ",", replacement = ""))
#      
#      df$a4 <- 
#        as.numeric(gsub(df$a4, pattern = ",", replacement = ""))
#      
#      df$a5 <- 
#        as.numeric(gsub(df$a5, pattern = ",", replacement = ""))
#      
#      df$a6 <- 
#        as.numeric(gsub(df$a6, pattern = ",", replacement = ""))
#      
#      
#      
#      df$b1 <- 
#        as.numeric(gsub(df$b1, pattern = ",", replacement = ""))
#      
#      df$b2 <- 
#        as.numeric(gsub(df$b2, pattern = ",", replacement = ""))
#      
#      df$b3 <- 
#        as.numeric(gsub(df$b3, pattern = ",", replacement = ""))
#      
#      df$b4 <- 
#        as.numeric(gsub(df$b4, pattern = ",", replacement = ""))
#      
#      df$b5 <- 
#        as.numeric(gsub(df$b5, pattern = ",", replacement = ""))
#      
#      df$b6 <- 
#        as.numeric(gsub(df$b6, pattern = ",", replacement = ""))
#      
#      
#      df$reserva <- NA
#      
#      for (i in 1:nrow(df)) {
#        
#        if (is.na(df$b4[i]) == F) {
#          df$reserva[i] <- df$b4[i]
#          
#        } else if (is.na(df$b3[i]) == F) {
#          
#            df$reserva[i] <- df$b3[i]
#            
#          } else if (is.na(df$b2[i]) == F) {
#            
#            df$reserva[i] <- df$b2[i]
#              
#            } else {
#              
#              df$reserva[i] <- df$b1[i]
#                
#              } }  
# 
#      
#      df_USGS <- 
#        rbind(df_USGS,
#          df[,c("substancia", "pais", "reserva")])
#      
#      
#   # USGS_5  ----
#      df <- USGS_5  
#      
#      df$pais <- 
#        gsub(df$X1, pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#        gsub(df$X1, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#        gsub(df$X1, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% str_trim()
#      df$pais <- gsub(df$pais, pattern = "[0-9]|[-]|[,]", replacement = "") %>% str_trim()
#      df$numeros_b <- 
#        gsub(df$X4, pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#        gsub(df$X4, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#        gsub(df$X4, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>%
#        gsub(df$X4, pattern = "[a-z]|[A-Z]|[()]", replacement = "") %>% 
#        gsub(df$X4, pattern = "1000001", replacement = "NA") %>% str_trim()
#      
#      
#      df <- 
#        separate(
#          df, col = "numeros_b", into = c("b1","b2","b3",'b4',"b5",'b6'),sep = " ") #  %>% View()
#      
#      
#      df$b1 <- 
#        as.numeric(gsub(df$b1, pattern = ",", replacement = ""))
#      
#      df$b2 <- 
#        as.numeric(gsub(df$b2, pattern = ",", replacement = ""))
#      
#      df$b3 <- 
#        as.numeric(gsub(df$b3, pattern = ",", replacement = ""))
#      
#      df$b4 <- 
#        as.numeric(gsub(df$b4, pattern = ",", replacement = ""))
#      
#      df$b5 <- 
#        as.numeric(gsub(df$b5, pattern = ",", replacement = ""))
#      
#      df$b6 <- 
#        as.numeric(gsub(df$b6, pattern = ",", replacement = ""))
#      
#      
#      df$reserva <- NA
#      
#      for (i in 1:nrow(df)) {
#        
#        if (is.na(df$b4[i]) == F) {
#          df$reserva[i] <- df$b4[i]
#          
#        } else if (is.na(df$b3[i]) == F) {
#          
#          df$reserva[i] <- df$b3[i]
#          
#        } else if (is.na(df$b2[i]) == F) {
#          
#          df$reserva[i] <- df$b2[i]
#          
#        } else {
#          
#          df$reserva[i] <- df$b1[i]
#          
#        } }  
#      
#      df_USGS <- 
#        rbind(df_USGS,
#              df[,c("substancia", "pais", "reserva")])
#      
# 
# # MINÉRIO DE FERRO E POTÁSSIO SÃO CASOS EXCEPCIONAIS     
#      
#           
#    # USGS_6  ----
#      df <- USGS_6  
#      
#      df$pais <- 
#        gsub(df$X1, pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#        gsub(df$X1, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#        gsub(df$X1, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% str_trim()
#      df$pais <- gsub(df$pais, pattern = "[0-9]|[-]|[,]", replacement = "") %>% str_trim()
# 
#      df <- # Potássio
#        df[21:35,]
#      
#      df$Recoverable_ore <- 
#        df$X4
#      
#      df$K2O_equivalent <- 
#        df$X5
#      
#      df$Recoverable_ore <- 
#        as.numeric(gsub(df$Recoverable_ore, pattern = ",", replacement = ""))
#      
#      df$K2O_equivalent <- 
#        as.numeric(gsub(df$K2O_equivalent, pattern = ",", replacement = ""))
# 
#      df$Recoverable_ore[is.na(df$Recoverable_ore)] <- 0
#      
#      df$K2O_equivalent[is.na(df$K2O_equivalent)] <- 0
#      
#      df$reserva <- 
#        df$K2O_equivalent + df$Recoverable_ore
#      
#      
#      df_USGS <- 
#        rbind(df_USGS,
#              df[,c("substancia", "pais", "reserva")])
#      
#      
#      # USGS_8  ----
#      # MINÉRIO DE FERRO
#      
#      df <- USGS_8  
#      
#      df$pais <- 
#        gsub(df$X1, pattern = "NA| W |^W$|\tW\t|[-]", replacement = " 1000001 ") %>% 
#        gsub(df$X1, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% 
#        gsub(df$X1, pattern = " W |^W$|\tW\t", replacement = " 1000001 ") %>% str_trim()
#      df$pais <- gsub(df$pais, pattern = "[0-9]|[-]|[,]", replacement = "") %>% str_trim()
#      df$reserva <- # contido
#        gsub(df$X7, pattern = ",",replacement = "") %>% as.numeric()
#      
#      
#      df_USGS <- 
#        na.omit(
#          rbind(df_USGS,
#              df[,c("substancia", "pais", "reserva")]))
#      
#      df_USGS$substancia <- 
#        as.character(df_USGS$substancia) 
#      
#      
#      write.table(
#        x = df_USGS,
#        file = "D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Sumário_Mineral/Sumário_RMarkdown/df_USGS_Reservas.csv",
#        sep = ";",
#        row.names = FALSE,
#        fileEncoding = "UTF-8")
#      

# # extract_areas
# Amianto <- extract_tables(file = USGS_summaries, pages = c(31))
# Berílio <- extract_tables(file = USGS_summaries, pages = c(37))
# Ouro <- extract_tables(file = USGS_summaries, pages = c(75))
