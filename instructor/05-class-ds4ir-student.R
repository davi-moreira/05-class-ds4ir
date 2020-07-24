# ---
#   title: "DS4IR"
# subtitle: "Visualização de dados II: Mapas"
# author: 
#   - Professor Davi Moreira
# - Professor Rafael Magalhães
# date: "`r format(Sys.time(), '%d-%m-%Y')`"
# output: 
#   revealjs::revealjs_presentation:
#   theme: simple
# highlight: haddock
# transition: slide
# center: true
# css: stylesheet.css
# reveal_options:
#   controls: false  # Desativar botões de navegação no slide
# mouseWheel: true # Passar slides com o mous e
# ---
#   
#   ## Programa
#   1. Dados geoespaciais
# 2. Elaboração de mapas
# 
# ## Minard: A Campanha Russa de Napoleão
# 
# <center>
#   ![Minard](images/minard.png)
# [Link em alta resolução](https://upload.wikimedia.org/wikipedia/commons/2/29/Minard.png)
# </center>
#   
#   ## Carregando os pacotes para a aula
#   
#   
#   ```{r echo=FALSE, message=FALSE, warning=FALSE, results='hide'}
# # pacotes necessários
library(ggrepel)
library(gridExtra)
library(lubridate)
library(rgdal) 
library(maptools)
library(ggmap)
library(mapproj)
library(geobr)
library(sf)
library(rio)
library(stringr)
library(maps)
library(readxl)
library(tidyverse)
library(here)
#
# configuracao para desabilitar notacao cientifica
options(scipen = 999) 
#
# 
# 
# # ## Shapefile
# 
# O IBGE divulga bases cartográficas do país em diferentes níveis. Chamados 
# de `shapefiles`, estes arquivos serão utilizados para produção de mapas no `R`.
# 
# [Malhas digitais](https://mapas.ibge.gov.br/bases-e-referenciais/bases-cartograficas/malhas-digitais)
# 
# ```{r message=FALSE, warning=FALSE, results='hide'}
# # importando dados
shapefile_pe <- readOGR(here("./data/pe_municipios/"))
# 
# ```
# 
# ## Nosso primeiro mapa
# 
# ```{r message=FALSE, warning=FALSE, results='hide', fig.align="center", fig.height=5}
plot(shapefile_pe)
# 
# ```
# 
# ## Vamos consultar o objeto com o `shapefile`
# 
# ```{r eval=FALSE, message=FALSE, warning=FALSE, results='hide'}
shapefile_pe@data
# 
# ```
# 
# ## Convertendo o shapefile para dataframe
#```{r message=FALSE, warning=FALSE, results='hide'}
shapefile_df <- fortify(shapefile_pe)

dim(shapefile_df)
names(shapefile_df)
head(shapefile_df)

shapefile_data <- fortify(shapefile_pe@data)
shapefile_data$id <- row.names(shapefile_data)

shapefile_df <- shapefile_df %>% full_join(shapefile_data, by="id") %>% as_tibble()

# ```
# 
# ## Mapas com o `ggplot2`
# 
# ```{r message=FALSE, warning=FALSE, fig.align="center", fig.height=3}
shapefile_df %>% ggplot() +
  geom_polygon(aes(x = long, y = lat, group = group), 
               colour = "black", fill = 'white', size = .2) + 
  coord_map()
# ```
# 
# ## Exercício:
# 
# Produza o mapa do Estado de Pernambuco sem Fernando de Noronha (CD_GEOCMU == 2605459).
# 
# ## Exercício: resposta
# 
# 
#   ## PNUD: agregando valor 
#   
#   O [Atlas do Desenvolvimento Humano no Brasil](http://www.atlasbrasil.org.br/2013/) traz o Índice de Desenvolvimento Humano 
# Municipal (IDHM) e outros 200 indicadores de demografia, educação, renda, trabalho, 
# habitação e vulnerabilidade para os municípios brasileiros. 
# 
# ```{r message=FALSE, warning=FALSE}
# # importando dados
pnud <- read_excel(here("data", "atlas2013_dadosbrutos_pt.xlsx"), sheet = 2)

pnud <- pnud %>% mutate(Codmun7 = as.character(Codmun7))
# 
# ```
# 
# ## Exercício
# 
# Produza um mapa de calor que apresente visualmente o `IDHM` dos municípios do Estado 
# de Pernambuco (26) no ano de 2010 sem considerar Fernando de Noronha (2605459).
# 
# ## Exercício: resposta
# 
# 
#   ## World Map
#   
#   ```{r message=FALSE, warning=FALSE}
world <- map_data("world") %>% as_tibble()

# ```
# 
# ## Exercício
# 
# Produza uma mapa mundi no qual os países estejam prenchidos com a cor `"#2D3E50"`
# e suas fronteiras com `"#FEBF57"`.
# 
# ## Exercício: resposta
# 
# 
# ## Mapas com o `ggmap` e o Google Maps
#   
#   Recentemente o Google Maps passou a exigir de todos os desenvolvedores uma API 
# específica para uso gratuito do serviço.
# 
# - Para cadastrar um projeto e fazer obter uma API, utilize este 
# [link](https://cloud.google.com/maps-platform/user-guide/account-changes/#no-plan).
#          
#  - Para informações sobre esta mudança, veja:
#  
#  - [README `ggmap`](https://github.com/dkahle/ggmap).
# 
# - [GitHub do pacote ggmap](https://github.com/dkahle/ggmap).
# 
# - [GitHub do pacote ggmap - Issue 51](https://github.com/dkahle/ggmap/issues/51).
# 
# - [Questão 1 StackOverflow](https://stackoverflow.com/questions/52565472/r-get-map-not-passing-the-api-key).
# 
# - [Questão 2 StackOverflow](https://stackoverflow.com/questions/19827598/error-in-get-map-using-ggmap-in-r?rq=1).
# 
# ## Mapas com o `ggplot2` e o Google Maps
# 
# ```{r echo = FALSE, message=FALSE, warning=FALSE, fig.align="center", fig.height=5}
# carregando pacote
# if(!requireNamespace("devtools")) install.packages("devtools")
# devtools::install_github("dkahle/ggmap", ref = "tidyup")
library("ggmap")

# registrando api

register_google(key = "sua_api_aqui")

# mapas
get_map("São Paulo") %>% ggmap()
# ```
# 
# ## Mapas com o `ggplot2` e o Google Maps
# 
# ```{r echo = FALSE, message=FALSE, warning=FALSE, fig.align="center", fig.height=5}
get_map("São Paulo", maptype = c("satellite")) %>% ggmap()
# ```
# 
# ## Mapas com o `ggplot2` e o Google Maps
# 
# ```{r echo = FALSE, message=FALSE, warning=FALSE, fig.align="center", fig.height=5}
get_map("São Paulo", zoom = 10) %>% ggmap()
# ```
# 
# ## Mapas com o `ggplot2` e o Google Maps
# 
# ```{r echo = FALSE, message=FALSE, warning=FALSE, fig.align="center", fig.height=5}
get_map("São Paulo", zoom = 12) %>% ggmap()
# ```
# 
# ## Mapas com o `ggplot2` e o Google Maps
# 
# ```{r echo = FALSE, message=FALSE, warning=FALSE, fig.align="center", fig.height=5}
sp1 <- get_map("Av 9 de julho, 2029, São Paulo - SP", zoom = 15)
ggmap(sp1)
# ```
# 
# ## Mapas com o `ggplot2` e o Google Maps
# 
# ```{r echo = FALSE, message=FALSE, warning=FALSE, fig.align="center", fig.height=5}
fgv <- geocode("FGV EAESP")
# fgv

ggmap(sp1) + geom_point(data = fgv, aes(lon, lat), color = "red", size = 2)  
# ```
# 
# ## Mapas com o `ggplot2` e o Google Maps
# 
# ```{r echo = FALSE, message=FALSE, warning=FALSE, fig.align="center", fig.height=5}
fgv_ri <- geocode("FGV Escola de Relações Internacionais")

sp1 %>% ggmap() + geom_point(data = fgv, aes(lon, lat), 
                            color = "red", size = 2) +  
 geom_point(data = fgv_ri, aes(lon, lat), color = "blue", size = 2)
# ```
# 
# ## Minard: A Campanha Russa de Napoleão
# 
# 
# ## Minard: A Campanha Russa de Napoleão
# 
# <center>
#  ![Minard](images/minard.png)
# [Link em alta resolução](https://upload.wikimedia.org/wikipedia/commons/2/29/Minard.png)
# </center>
#  
#  ## "O melhor gráfico estatístico da história"
#  O gráfico representa, de maneira concisa, clara e elegante, 6 informações diferentes: 
#  número de soldados, distância, temperatura, localização precisa de rios e cidades, 
# direção de ataque e de recuo, e localização relativa às datas.
# 
# Mas será que conseguimos reproduzi-lo no R? ([código original](https://github.com/andrewheiss/fancy-minard) e [dados](http://www.datavis.ca/gallery/re-minard.php))
# 
# ```{r message=FALSE, warning=FALSE, results='hide'}
# 
# # carregar os dados
troops <- read_table2(here("data", "troops.txt"))
cities <- read_table2(here("data", "cities.txt"))
temps <- read_table2(here("data", "temps.txt"))
# 
# ```
# 
# ## Primeiros passos - mapeando as tropas
# ```{r fig.height = 5, fig.align="center"}
troops %>% ggplot() +
 geom_path(aes(x = long, y = lat, group = group))
# ```
# 
# ## Direção e sobreviventes
# ```{r fig.height = 5, fig.align="center"}
troops %>% ggplot() +
 geom_path(aes(x = long, y = lat, group = group, color = direction, size = survivors))
# ```
# 
# ## Ajustes estéticos
# ```{r fig.height = 4, fig.align="center"}
troops %>% ggplot() +
 geom_path(aes(x = long, y = lat, group = group, color = direction, size = survivors),
           lineend = "round") + # linhas arredondadas para melhor efeito
 scale_size(range = c(0.5, 15)) # desagrega o número de categorias na escala
# ```
# 
# ## Reproduzindo as cores do gráfico original
# ```{r fig.height = 3, fig.align="center"}
troops %>% ggplot() +
 geom_path(aes(x = long, y = lat, group = group, color = direction, size = survivors),
           lineend = "round") + # linhas arredondadas para melhor efeito
 scale_size(range = c(0.5, 15)) + # desagrega o número de categorias na escala
 scale_colour_manual(values = c("#DFC17E", "#252523")) + # cores originais
 labs(x = NULL, y = NULL) + # tira os rótulos dos eixos
 guides(color = FALSE, size = FALSE) # tira os tiques dos eixos
# ```
# 
# ## Adicionando as cidades (gráfico no próximo slide)
# ```{r fig.height = 3.5, fig.align="center", fig.show="hide"}
# Agora estamos chamando os dados dentro de cada geom. Por quê?
ggplot() +
 geom_path(data = troops, aes(x = long, y = lat, group = group, color = direction, size = survivors), lineend = "round") +
 geom_point(data = cities, aes(x = long, y = lat), color = "#DC5B44") +  # loc. das cidades
 geom_text_repel(data = cities, aes(x = long, y = lat, label = city), # nomes das cidades
                 color = "red", size = 3, fontface = "bold") + 
 scale_size(range = c(0.5, 15)) + 
 scale_colour_manual(values = c("#DFC17E", "#252523")) +
 labs(x = NULL, y = NULL) + 
 guides(color = FALSE, size = FALSE) +
 theme_void() # tira todos os elementos do gráfico
# ```
# 
# ## Finalizando a parte de cima!
# ```{r echo=FALSE, fig.align="center", fig.height=5}
grafico_marcha <- ggplot() +
 geom_path(data = troops, aes(x = long, y = lat, group = group, color = direction, size = survivors), lineend = "round") +
 geom_point(data = cities, aes(x = long, y = lat), color = "#DC5B44") +  # loc. das cidades
 geom_text_repel(data = cities, aes(x = long, y = lat, label = city), # nomes das cidades
                 color = "red", size = 3, fontface = "bold") + 
 scale_size(range = c(0.5, 15)) + 
 scale_colour_manual(values = c("#DFC17E", "#252523")) +
 labs(x = NULL, y = NULL) + 
 guides(color = FALSE, size = FALSE) +
 theme_void() # tira todos os elementos do gráfico

grafico_marcha
# ```
# 
# ## O gráfico de temperaturas
# ```{r fig.height = 5, fig.align="center"}
temps %>% ggplot(aes(x = long, y = temp)) +
 geom_line() +
 geom_text(aes(label = temp), vjust = 1.5)
# ```
# 
# ## Limpando o layout e Finalizando a parte de baixo!
# ```{r echo=FALSE, fig.align="center", fig.height=5, message=FALSE, warning=FALSE}
# # Melhorando a apresentação dos dados
temps.nice <- temps %>% mutate(nice.label = paste0(temp, "°, ", month, ". ", day))

# Melhorando a apresentação dos dados
temps.nice <- temps %>%
 mutate(nice.label = paste0(temp, "°, ", month, ". ", day))

grafico_temperaturas <- ggplot(data = temps.nice, aes(x = long, y = temp)) +
 geom_line() + # linha
 geom_label(aes(label = nice.label), size = 2.5) + # rótulos
 labs(x = NULL, y = "° Celsius") + # escalas
 scale_x_continuous(limits = c(23.5, 38.1)) + # coincidir escala com o gráfico da marcha
 scale_y_continuous(position = "right") + # eixo y na direita
 coord_cartesian(ylim = c(-35, 5)) +  # espaçamento
 theme_bw() + # ajustes no tema
 theme(panel.grid.major.x = element_blank(),
       panel.grid.minor.x = element_blank(),
       panel.grid.minor.y = element_blank(),
       axis.text.x = element_blank(), axis.ticks = element_blank(),
       panel.border = element_blank())

grafico_temperaturas
# ```
# 
# ## Incluindo dados geográficos
# Uma das qualidades do gráfico do Minard é a precisão geográfica. Isso quer dizer 
# que podemos colocar o nosso código em um mapa da Europa, e saber exatamente o caminho 
# das tropas. Essa é uma boa oportunidade de apresentar a vocês o pacote `ggmap`
# 
# ```{r fig.show="hide", message=FALSE, warning=FALSE}
library(ggmap)

recorte_europa <- c(left = -13.10, bottom = 35.75, right = 41.04, top = 61.86) 
europa <- get_stamenmap(bbox = recorte_europa, zoom = 5, maptype = "toner-lite", where = "cache")

europa %>% ggmap() +
 geom_path(data = troops, aes(x = long, y = lat, group = group, color = direction, size = survivors),
           lineend = "round") +
 scale_size(range = c(0.5, 5)) + 
 scale_colour_manual(values = c("#DFC17E", "#252523")) +
 guides(color = FALSE, size = FALSE) +  theme_nothing()
# ```
# 
# ## A invasão no contexto europeu
# ```{r echo=FALSE, fig.align='center', message=FALSE, warning=FALSE}
europa %>% ggmap() +
 geom_path(data = troops, aes(x = long, y = lat, group = group, 
                              color = direction, size = survivors),
           lineend = "round") +
 scale_size(range = c(0.5, 5)) + 
 scale_colour_manual(values = c("#DFC17E", "#252523")) +
 guides(color = FALSE, size = FALSE) +
 theme_nothing()
# ```
# 
# ## Zoom: Mapa da campanha russa
# ```{r fig.align="center", echo=FALSE, message=FALSE, warning=FALSE}
recorte_minard <- c(left = 23.5, bottom = 53.4, right = 38.1, top = 56.3)
area_minard <- get_stamenmap(bbox = recorte_minard, zoom = 8, maptype = "toner-lines", where = "cache")

mapa <- ggmap(area_minard) +
 geom_path(data = troops, aes(x = long, y = lat, group = group, color = direction, size = survivors), lineend = "round") +
 geom_point(data = cities, aes(x = long, y = lat), color = "#DC5B44") +  # loc. das cidades
 geom_text_repel(data = cities, aes(x = long, y = lat, label = city), # nomes das cidades
                 color = "red", size = 3, fontface = "bold") + 
 scale_size(range = c(0.5, 15)) + 
 scale_colour_manual(values = c("#DFC17E", "#252523")) +
 labs(x = NULL, y = NULL) + 
 guides(color = FALSE, size = FALSE) + theme_nothing()

mapa
# ```
# 
# ## Últimos ajustes
# ```{r fig.align="center", fig.height=5, fig.show="hide", message=FALSE, warning=FALSE}
# Juntar dados de ambos os gráficos
ambos <- gtable_rbind(ggplotGrob(mapa), ggplotGrob(grafico_temperaturas))

# Ajustando paineis
paineis <- ambos$layout$t[grep("panel", ambos$layout$name)]
map.panel.height <- ambos$heights[paineis][1]
ambos$heights[paineis] <- unit(c(map.panel.height, 0.1), "null")

# Exibindo ambos os gráficos juntos
grid::grid.newpage()
grid::grid.draw(ambos)
# ```
# 
# ## Combinando as duas partes!
# ```{r echo=FALSE, fig.align="center", message=FALSE, warning=FALSE}
grid::grid.newpage()
grid::grid.draw(ambos)
# ```
# 
# ## Material adicional
# 
# - [Git IPEA](https://github.com/ipeaGIT)
# 
# ## Tarefa da aula
# 
# As instruções da tarefa estão no arquivo `NN-class-ds4ir-assignment.rmd` da pasta 
# `assignment` que se encontra na raiz desse projeto.











