<style> body {background: beige; font-size: small;} p, li {color: #333333} table {align-self: center; } h1 {color: darkslateblue;} h2 {color: darkslateblue;} h3 {color: darkslateblue;} h4 {color: darkslateblue;} h5 {color: darkslateblue;} </style>

## Sumário Mineral 4.0
<div style="text-align: right; font-size: 11pt;"> 
<a href="mailto:humberto.serna@anm.gov.br"> humberto.serna@anm.gov.br </a>  
</div>


Essa é uma versão experimental do *Sumário Mineral Brasileiro* usando tecnologia de automação web. Para cada substância o texto respectivo foi gerado por um *bot*, criado na própria GEMI, programado para combinar bases próprias com bases coletadas em Dados Abertos na Internet. O resultado são combinações de variáveis (produção, exportações, teor, etc) com frases geradas previamente conforme ajuste de semântica ao contexto de cada parágrafo.

O objetivo dos textos prontos é ganho de tempo aos autores. Com benefício de liberar o trabalho repetitivo em benefício de mais tempo para análise crítica. Foram usadas as linguagens *R* (para automação) e as linguagens *HTML* e *CSS* (no layout). Agradeço ao colega Adhelbar Queiroz no aconselhamento sobre diversas substâncias.


<br />

> #### Substâncias Alvo (31)
>
> *Água Mineral, Alumínio, Areia, Brita, Calcário, Carvão Mineral, Caulim, Chumbo, Cobalto, Cobre, Cromo, Estanho, Ferro, Fosfato, Grafita, Lítio, Magnesita, Manganês, Nióbio, Níquel, Ouro, Potássio, Prata, Rochas ornamentais, Tântalo, Terras Raras, Titânio, Tungstênio, Vanádio, Zinco, Zircônio*

<br />


> #### Nomenclatura & definições
> 
> - #####Fontes utilizadas: 
>    - **Produção Nacional**: AMB Dados Abertos. Nesta fonte as substâncias constam reunidas sob Substância Agrupadora. Para algumas substâncias o ideal era o agrupamento por Substância AMB (Dolomito & Magnesita; Monazita & Terras Raras).
>    - **Reservas Nacionais**: Planilha complementar AMB Web. Para hamonização com produção nacional foi usada a substância agrupadora (exceções tratadas caso a caso, ver em **Comentários**)
>    - **Reservas Internacionais**: USGS commodity summary
>    - **Produção Internacional**: [World Mining Data (Austria)](https://www.world-mining-data.info/); [Bp Statistical Review of World Energy 2020](https://www.bp.com/en/global/corporate/energy-economics/statistical-review-of-world-energy.html "Para a substância CARVÃO MINERAL. Essa foi a recomendação do sumarista Luis (PR)")
>    - **Comércio exterior**: Comexstat MDIC
>    - Bases externas foram internalizadas via Matriz de Relacionamento
   


<br />

> ##### Comentários sobre casos particulares
>  
>  **Aluminio (Bauxita):** Para fins de compatibilidade o registro "Alumínio" da Mtz de Relacionamentos, foi renomeado para *Alumínio (Bauxita)*. Ou não teríamos registros em Comex. Nos relatórios do *Summary Mineral Commodities (USGS)* consta *Alumínio* e *Bauxita* como separados. Consideramos esse último  
>  
>  **Carvão Mineral:** Não consta no *Summary Mineral Commodities (USGS)*, tendo sido usado bp-stats-review-2020-full-report_(COAL), conforme é a prática do sumarista Luis Araújo.   
>
>  **Grafita:** Originalmente sem símboloQuimico, imputei 'C' (carbono).
>  
>  **Terras-Raras:** No AMB Dados Abertos consta reunido sob a substância agrupadora *Monazita e Terras-Raras*. Embora o *Summary Mineral Commodities (USGS)* considere *Monazita* como recurso (e reserva) de *Terras Raras*, nas publicações da ANM/AMB elas são interpretadas como coisas distintas. O que foi feito, por ora, foi seguir a USGS e usado substância Agrupadora *Monazita e Terras-Raras*. Notei que não há *Monazita* na Mtz de Relacionamento e não foi possível gerar dados do Comex Stat.
>  
>  **Titânio:** Foi desconsiderada a substância AMB *Anatásio* nos registros nacionais. Isso conforme conversa com o sumarista Antônio Alves que reportou os teores do *Anatásio* nacional como sendo subeconômicos (recurso).
>  
>  **Magnesita:**  Sumários de anos anteriores não agrupavam Dolomito como sendo fonte de magnesita. Diferentemente, a USGS o faz[¹](#obs). Por ora, apresentamos o sumário sob a substância Agrupadora Dolomito & Magnesita[²](#obs) [³](#obs).  
>
>  **Ouro**: Requer ajuste da unidade da Reserva  
>
>  **AMB Dados Abertos x Planilhas Complementares**: recomendação de usar dados de planilhas complementares na versão definitiva. É que em dados abertos a agregação mínima é por Substância Agrupadora.  


<br />

|       RESERVAS          |          casos especiais:                                                                                |
|-------------------------|----------------------------------------------------------------------------------------------------------|
|       **Areia**         |          reportada como abundante, mas suscetível a insuficiências locais("*local shortages*")           |
|       **Brita**         |          reportada como abundante, mas suscetível a insuficiências locais("*local shortages*")         |
|       **Calcário**      |          reportada como abundante, mas suscetível a insuficiências locais("*local shortages*")          |
|       **Nióbio**        |          >13,000,000                                                                                     |
|       **Potássio**      |          >3,600,000                                                                                      |
|       **Tântalo**       |          >90,000                                                                                         |
|       **Rochas ornamentais**|      Não consta em Mineral Commodity Summary USGS. Estabeleci que a tabela com reservas será substituída pela frase *"reservas são adequadas mas sujeitas a escassez local (...)"*                                                                                                |
|       **Australia**     |          *"(...) have specific definitions for reserves data. The Australasian Joint Ore Reserves Committee (JORC) established the Australasian Code for Reporting of Exploration Results, Mineral Resources and Ore Reserves (the JORC Code) (...)"*                                |


  
<br />

***
###### obs

¹ *"(...) Resources from which magnesium compounds can be recovered range from large to virtually unlimited and are globally widespread. Identified world magnesite and brucite resources total 12 billion tons and several million tons, respectively. Resources of dolomite, forsterite, magnesium-bearing evaporite minerals, and magnesia-bearing brines are estimated to constitute a resource of billions of tons(...)"*  
² "*Dolomita é um dos principais minerais carbonáticos, sendo membro intermediário entre calcita (CaCO3) e magnesita (MgCO3). Apesar disso, a substituição entre cálcio e magnésio é apenas parcial, de forma que calcita e magnesita não constituem extremos de uma solução sólida completa*(...)"  
³  "*MAGNESIUM METAL: Magnesium metal is derived from seawater, natural brines, dolomite, serpentine, and other minerals (pg. 103)*"






<br />

<h4 style="text-align: center;"> ANEXO </h4>

</ br>
 Dicionário de Dados
</ br>

 <font size="2"> 

|Variável             | Tipo             |
|---------------------|--------------|
|**1. OFERTAMUNDIAL**      |                |
|Ano                | integer|
|Substância             | string|
|SimboloQuimico           | string|
|Países               | string|
|ProduçãoMundial          |   integer WMD|
|ProduçãoContidoMUNDIAL       | integer WMD|
|Reservas             | integer USGS|
|ReservasContido          |   integer USGS|
|                 ||
|**2. PRODUÇÃOINTERNA**     ||
|ProduçãoBrutaVendida Transferida | double (Venda, Tratamento Transformação Consumo)|
|UnidadeProdução          | string|
|UnidadeVenda           | string|
|UnidadeContido           | string (litros,gramas,quilates)|
|Teor               | double|
|Estado(UF)             | string|
|                 ||
|**3. COMÉRCIOEXTERIOR**      ||
|Saldo                | double|
|FatordeAgregação         | string (produtosbásicos/ semimanufaturado/ manufaturados) CHECAR|
|Produtos             | string|
|NCM                | integer|
|Países               | string|
|                 ||
|**4. PREÇOS**          ||
|Preço                | Double|
|Unidade_Preço            | string (USD/t USD etc)|
|Produtos             | string|
|NCM                | integer|




MAGNESIUM COMPOUNDS
Resources of dolomite, forsterite, magnesium-bearing evaporite minerals, and magnesia-bearing brines are estimated to constitute a resource of billions of tons

LIME
world resources of limestone and dolomite suitable for lime manufacture are very large.
 
</font> 
 <br>

#### Escalas e unidades 
  
 <font size="1"> 


  |  SUBS  |  Contido Medido  |  Contido Medido Ano Anterior  |  Contido Medido MUN  |  Contido Medido UF  |  unidade Produção Beneficiada  |  Produção Beneficiada  |  Produção Beneficiada ANO  |  Produção Beneficiada UF  |  unidade do contido AMB  |  Produção  USGS  |  Produção CONTIDO  |  Produção CONTIDO ANO  |  Produção CONTIDO UF  |  Reserva Medida  |  Reserva Medida Ano Anterior  |  Reserva Medida MUN  |  Reserva Medida UF  | 
|   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   |   :------:   | 
  |  Alumínio (Bauxita)  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Calcário  | nd | nd | nd | nd |  t  |  mil  | nd | nd |  -  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Caulim  | nd | nd | nd | nd |  t  |  mil  | nd | nd |  -  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Carvão Mineral  | nd | nd | nd | nd |  t  |  mil  | nd | nd |  -  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Chumbo  |  mil  |  mil  | nd |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Cobalto  | nd | nd | nd | nd |  t  |  mil  | nd | nd |  t  |  0  |  mil  | nd | nd |  mil  |  mil  |  mil  |  mil  |  
  |  Cobre  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Cromo  |  mil  |  mil  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  mil  |  milhões  |  mil  |  mil  |  
  |  Dolomito e Magnesita  | nd | nd | nd | nd |  t  |  mil  | nd | nd |  -  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Estanho  |  milhões  |  milhões  |  mil  |  mil  |  kg  |  mil  | nd | nd |  kg  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Ferro  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Fosfato  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Grafita  |  mil  |  mil  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Lítio  |  mil  | nd |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  mil  |  mil  |  mil  |  
  |  Manganês  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Monazita e Terras-Raras  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Nióbio  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  0  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Níquel  |  mil  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Ouro  |  milhões  |  milhões  |  mil  |  mil  |  kg  |  mil  | nd | nd |  kg  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Potássio  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Prata  |  milhões  |  milhões  |  mil  |  mil  |  kg  |  mil  | nd | nd |  kg  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Tântalo  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  0  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Titânio  |  milhões  |  milhões  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Tungstênio  |  mil  |  mil  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  0  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Vanádio  |  mil  |  mil  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  0  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Zinco  |  mil  |  mil  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |  
  |  Zircônio  |  mil  |  mil  |  mil  |  mil  |  t  |  mil  | nd | nd |  t  |  1  |  mil  | nd | nd |  milhões  |  milhões  |  mil  |  mil  |


  
</font>