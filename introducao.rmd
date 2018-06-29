---
title: "Introdução ao R para Jornalistas"
author: "Manoel Galdino e Jessica Voigt"
date: "12 de junho de 2018"
output: html_document
---

## Início

Essa é o tutorial para o curso de R para jornalistas. Ao longo do dia iremos:

    1. Conhecer o R;
    2. Importar planilhas em formatos .xlsx (Excel) e .csv no R;
    3. Criar tabelas e visualizações com os verbos do dplyr;
    4. Exportar bancos de dados;
    5. Juntar diferentes bancos de dados com o left_join;
    6. Trabalhar problemas do mundo real na parte 2;
    7. Aprender a usar as funções gather() e spread() do tidyr.


## Primeiros passos

Antes de começarmos, precisamos entender algumas coisas sobre o R:


### O que é uma linguagem?

Quando falamos que *R é uma linguagem* queremos dizer que através do R utilizamos uma forma específica para nos comunicarmos com o computador. Através dessa linguagem, podemos fazer perguntas e comandos para o computador e ele nos dirá a resposta. 

**Computadores não são inteligentes, eles são bons para observar padrões.** 

Por isso, sempre verifique se você digitou *corretamente* as funções no R. Muitos dos problemas enfrentados pelos usuários são causados por uma vírgula fora do lugar.

### Por quê usar o R? 

    1. Método Seguro;
    2. Rapidez;
    3. Possui uma grande comunidade.

### R e Rstudio

O R é uma linguagem de programação voltada para análise de dados e um software gratuito para compilação de dados. Já o Rstudio é uma IDE (*Integrated Development Enviroment*) que nos ajuda a visualizar o código e o que está armazenado para uso na memória RAM, sendo assim mais *"amigável"* que o R. Para usar o RStudio é necessário ter o R no seu computador. 

No curso de hoje não precisaremos instalar o R nem o RStudio, mas caso deseje instala-los no seu computador pessoal, [siga o tutorial disponível aqui](https://github.com/voigtjessica/curso_R_ABRAJI_28062018/blob/master/como_instalar_r.rmd) .


## 1. Conhecendo o R

O **script** é a parte superior esquerda da tela, ele serve para que você escreva e armazene o código para verificação posterior. Essa é uma das maiores vantagens de se usar o R, pois você pode verificar o que você fez e corrigir eventuais erros que tenha cometido. Iremos escrever um comando no script, clicar em executar (run) ou apertar ctrl + enter, e o Rstudio vai executá-lo.

Na parte superior direita temos três abas: *Enviroment e History*, por enquanto vamos apenas trabalhar com a aba Enviroment. Nela podemos conferir os objetos que criamos ou importamos.

Na parte inferior direita estão as abas *Files, Plots, Packages, Help e Viewer*. Não vamos nos preocupar com essa parte nesse momento.

Na parte inferior esquerda está o console, é onde você verá a impressão dos códigos rodados e eventuais mensagens e erros.

### Como iremos trabalhar?

As partes cinzas desse documento são chamadas chunks. Copie e cole os chunks no seu script para executar as operações. Comente no próprio script as suas impressões e como você traduziria esse código para uma linguagem que você entenda. 

### Comentários

Ao fazer um script, é recomendável que você comente o seu código para demarcar etapas ou até mesmo lembrar para o que determinado comando serve. Para isso. utilize a #

```{r, eval=FALSE, warning=F, message=F}

######## Curso de R para jornalistas

# Assim é que se faz um comentário no script


```


### O que são objetos?


Tudo no R é um objeto, por exemplo o número π:

```{r, eval=TRUE, warning=F, message=F}

pi

```

E as funções também são objetos. Vejamos o exemplo da função sum (SOMA)

```{r, eval=TRUE, warning=F, message=F}

sum(2,3,4)

```

E nós podemos criar nós mesmos os nossos objetos utilizando <- 
Esses objetos ficarão disponíveis no *Global Environment* e, assim, poderemos utiliza-los depois.

```{r, eval=TRUE, warning=F, message=F}

resultado_da_soma <- sum(2,3,4)
resultado_da_soma

```

Ou

```{r, eval=TRUE, warning=F, message=F}

x <- 2
y <- 3
z <- 4

x+y+z

```


### Tipos ou classes de objetos no R

**Numeric** São números reais

```{r, eval=TRUE, warning=F, message=F}
4
```

**Character**: Vetores tipo texto, escritos entre aspas duplas ou simples:

```{r, eval=TRUE, warning=F, message=F}
"4"
'4'
```

### Pacotes

O R possui algumas funções nativa como, por exemplo, a função *sum()* .
No entanto, é possível importar novas funções e até mesmo bancos de dados por meio de pacotes. 

Para a aula de hoje, vamos importar o pacote *data.table* para usarmos o comando *fread*, que nos permite importar arquivos .csv de forma mais eficiente. Execute os comandos a seguir:

```{r, eval=TRUE, warning=TRUE, message=TRUE}

# Instalar o pacote na nossa máquina com a função install.packages()
# Aqui mostramos como comentário porque o pacote já está instalado:

# install.packages("data.table") #nome do pacote entre aspas

# Carregar a biblioteca com a função library() 
library(data.table) 

```

Ótimo.
Agora nós temos acesso ao comando *fread* e podemos importar o nosso banco de dados. Você só precisa carregar a biblioteca uma vez depois de abrir o R e iniciar a sessão. 

É uma prática comum indicar as bibliotecas que serão usadas no início do script, no entanto, longo do curso de hoje faremos um pouco diferente: sempre que utilizarmos um comando que pertence a uma biblioteca, vamos mostrar a biblioteca como um comentário. Vejam o exemplo a seguir (por favor, não rodem):


```{r, eval=FALSE}
#library(data.table) ou
#data.table:fread
idh <- fread(file = "idh.csv")
```


## 2. Importar planilhas em formatos .xlsx (Excel) e .csv no R

Agora que já sabemos como importar bibliotecas e como acessar objetos, vamos aprender a importar banco de dados. Vamos trabalhar com o banco de jogadores da fifa de 2018.

    1. Vá em https://goo.gl/XUWoyR e baixe o arquivo "fifa2018.xls" e o arquivo "idh.csv";
    2. Salve os arquivos em uma pasta conhecida.

### Importando arquivos em .csv

CSV significa *Comma Separated Values*, e é um tipo de arquivo para armazenar banco de dados. Nós podemos importar arquivos .csv com o comando *fread()* , da biblioteca *data.table*.

Primeiro, temos que avisar o computador onde está o arquivo que queremos importar. Para isso, cole o caminho onde está o seu arquivo entre aspas dentro da função *setwd()* . Lembre-se de que no R as barras apontam para a direita "/" como no exemplo abaixo:

```{r, eval=F, message=FALSE, warning=FALSE}
# Comandos nativos do R (não precisam de biblioteca)

# Definindo o caminho
setwd("C:/Users/jvoig/OneDrive/Documentos/curso_R_ABRAJI_28062018/bancos")

#Verificando o caminho:
getwd()

```

Agora vamos mostrar como importar o arquivo "idh.csv" e atribui-lo a um objeto chamado idh:

```{r, eval=F, message=FALSE, warning=FALSE}

# library(data.table)   
# Importar arquivo .csv
idh <- fread(file = "idh.csv")

# Comando nativo
# Abre em uma outra janela o dataframe
View(idh)

```

Por enquanto vamos deixar esse banco de lado. Voltaremos nele mais pra frente.

### Importando arquivos em excel .xls


Agora vamos importar o arquivo. Para isso, vamos usar a função *read_excel()* do pacote *readxl* por meio dos comandos disponíveis na interface do R Studio. A vantagem de importar arquivos excel dessa forma é poder verificar como cada coluna será importada e alterá-las, se necessário.

    Vá em *File >> Import Datasets >> from Excel >> Browse*

Algumas colunas estão corretamente classificadas como character(texto), mas outras terão de ser alteradas antes de importadas. As colunas "height", "caps" e "goals" estão como character, mas deveriam estar como numeric. Clique na seta ao lado do nome de cada coluna e mude a sua classe. 

Você poderá perceber que o código descrito no canto inferior direito irá se modificar conforme você vai alterando a classe das colunas. Após alterar a classe dessas três colunas, copie o código e clique em *import* . Por fim, cole o código no seu script para registro. Ele estará parecido com o código abaixo:

```{r, eval=FALSE, warning=FALSE, message=FALSE}
# Carregando a biblioteca readxl
library(readxl)

# Importando o dataframe e atribuindo ao objeto fifa2018
fifa2018 <- read_excel("C:/Users/jvoig/OneDrive/Documentos/curso_R_ABRAJI_28062018/bancos/fifa2018.xlsx", 
    col_types = c("text", "text", "text", 
        "text", "text", "text", "text", "text", 
        "numeric", "numeric", "numeric", 
        "text"))

# Abre em uma outra janela o dataframe
View(fifa2018)
```


Vamos agora dar uma olhada nesse banco?

## 3. Criar tabelas e visualizações com os verbos do dplyr

Se o R é uma linguagem, o dplyr é uma lista de verbos que nos permite "conversar" com a máquina de maneira mais eficaz. 
Durante o curso de hoje, vamos aprender a analisar dados utilizando os verbos do dplyr.

Primeiro vamos instalar e carregar a biblioteca:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

# install.packages("dplyr")
# Esse pacote já foi instalado no computador.
library(dplyr)

```

O dplyr possui um verbo próprio para verificar a base de dados, o *glimpse()* . Você pode utilizar em conjunto com os comandos acima. Com o glimpse, podemos conferir o nome, classe e as primeiras entradas de um data.frame.

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#library(dplyr)

# "olhar" o dataframe
glimpse(fifa2018)

```
######*Caps é o número de partidas feitas com a camisa da seleção

Saber qual é a class da variável é algo muito útil futuramente, quando juntarmos duas tabelas (join).

### O Pipe %>%

No pacote dplyr usamos o comando *pipe* %>%, que simula uma corrente que amarra um comando ao comando seguinte. Dessa forma, só precisamos indicar uma vez com qual dataframe estamos tabalhando. Em português, poderíamos ler o *pipe* como "então". 

### Criando novas variáveis

Para criar novas colunas ou sobrescrever uma coluna em um dataframe, utilizamos o verbo *mutate()*.

Se quisessemos dizer que todas essas linhas se referem a jogos de futebol, poderiamos criar uma nova coluna que indicasse o esporte:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

# dplyr:mutate

fifa2018_1 <- fifa2018 %>%  # Pegue o fifa2018 e atribua ao objeto fifa2018_1, então
  mutate(esporte = "futebol")  # Crie uma váriável chamada esporte com o valor "futebol"

glimpse(fifa2018_1)

```

Pronto, criamos uma coluna "esporte" com o valor único "futebol".

Agora, digamos que vocês estão elaborando as estatísticas dos jogadores antes da copa. Com essas informações da Fifa, seria interessante saber qual é a média de gols por jogador com a camisa da sua seleção. Para isso vamos criar uma nova coluna que divide o número de gols (goals) pelo número de jogos pela seleção (caps). 

```{r, eval=FALSE, message=FALSE, warning=FALSE}

fifa2018_1 <- fifa2018 %>% 
  mutate(media_gols = goals/caps)

glimpse(fifa2018_1)

```

Essa média ficou muito grande, não acham? 
Podemos controlar o número de casas decimais (no R representados pelo .) utilizando o *round()*, que arredonda números ou resultados de contas :

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#nativo:round

# Testando:
round(4.567899765 , 1) #uma casa decimal
round(4.567899765 , 3) #três casas decimais

# Agora em um dataframe:
fifa2018_1 <- fifa2018 %>%  
  mutate(media_gols = round(goals/caps , 1)) 

glimpse(fifa2018_1)

```

Melhor, não?

O mutate pode ser usado tanto para criar uma nova variável completamente nova quanto para sobreescrever variáveis que já existem. 

Vejamos um exemplo: a altura dos jogadores está em cm, que tal se ela estivesse em metros? Basta sobrescrever:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

fifa2018_1 <- fifa2018 %>%  
  mutate(height = (height/100))

glimpse(fifa2018_1)

```

O mutate também pode mudar apenas a classe da variável. Lembra de como nós mudamos as variáveis "height", "caps" e "goals" de character para numeric ? Poderíamos ter feito isso também com o mutate.
Vejamos primeiro como podemos transformar a classe de vetores:

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#nativo: as.numeric
#nativo: as.character

# Exemplo

vetor_texto <- c("22", "23", "24")        #criando o vetor
class(vetor_texto)                        #verificando a classe do vetor 

# Transformando em numeric:
vetor_texto <- as.numeric(vetor_texto)    
class(vetor_texto)

# Transformando outra vez em character:
vetor_texto <- as.character(vetor_texto)
class(vetor_texto)

```

Viram? Com as funções nativas do R *as.numeric()* e *as.character()* podemos transformar um objeto de uma classe em outra. 

Agora vamos aplicar o que aprendemos no dafatrame da fifa. Vamos:

1. Transformar a coluna "goals" em character e atribuir ao objeto fifa2018_1,
2. Depois sobrescrever o objeto fifa2018_1 e transformar "goals" em numeric outra vez:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

fifa2018_1 <- fifa2018 %>%
  mutate(goals = as.character(goals))

glimpse(fifa2018_1)

# Viram? e agora outra vez:

fifa2018_1 <- fifa2018_1 %>%
  mutate(goals = as.numeric(goals))

glimpse(fifa2018_1)
```

### Modificando datas

Vocês devem ter reparado que não mudamos a coluna day_of_birth no momento da importação. Datas costumam ser complicadas e requerem um tratamento especial.

Assim como *as.character()* e *as.numeric()*, nós temos o comando *as.Date()* - sim, com D maiúsculo - que transforma um vetor em vetor de data. Então, para classificar um vetor ou coluna de texto para data, temos que aplicar o *as.Date()* e mostrar ao R como ele deve ler a data, em outras palavras indicar o dia, o mês e o ano e qual é o separador usado. 

Vamos ver o *as.Date()* utilizado junto com o *mutate()* no exemplo abaixo:

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#nativo:as.Date

#Vamos verificar como estão a data no nosso dataframe:
glimpse(fifa2018)

# "10.02.1986" -> "%d.%m.%Y"

# Agora vamos transformar em data com o mutate:
fifa2018_1 <- fifa2018 %>%
  mutate(day_of_birth = as.Date(day_of_birth, format="%d.%m.%Y"))

glimpse(fifa2018_1)
```

Caso queria estudar mais tarde outras transformações em datas, [clique aqui](https://github.com/voigtjessica/curso_R_ABRAJI_28062018/blob/master/vetor_em_datas.rmd) .


Agora vamos aplicar todas as transformações que já fizemos juntas? Para isso, basta "colar" um comando ao outro com o pipe:



```{r, eval=FALSE, message=FALSE, warning=FALSE}

fifa2018_1 <- fifa2018 %>%     
  mutate(esporte = "futebol") %>%                # Esporte = Futebol
  mutate(media_gols = round(goals/caps, 1)) %>%  # Coluna de média de gols por jogos com 1 casa decimal
  mutate(height = (height/100)) %>%              # Altura dos jogadores em metros
  mutate(day_of_birth = as.Date(day_of_birth, format="%d.%m.%Y"))  # Convertendo dia do nascimento em data.

glimpse(fifa2018_1)
```

Agora, ficar repetindo o comando (mutate) é muito chato. Lembrem-se: **programadores são preguiçosos**. No dplyr, você pode dizer o comando uma vez e colocar tudo o que diz respeito àquele comando dentro do parenteses. Então o nosso código ficaria assim:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

fifa2018_1 <- fifa2018 %>%  
  mutate(esporte = "futebol",
         media_gols = round(goals/caps , 1),
         height = (height/100),
         day_of_birth = as.Date(day_of_birth, format="%d.%m.%Y"))

glimpse(fifa2018_1)
```

Mais limpo, não acham? E como não fechamos o parenteses do *mutate()*, não precisams colocar o pipe para continaur com o código.

###Renomeando variáveis:

Para renomear variáveis, usamos o *rename()* do pacote dplyr, indicando primeiro o nome novo e depois o nome antigo.

Importante: o R tem dificuldade em ler nomes com espaços e acentuação. Fora isso, é uma boa prática sempre deixar todas as letras das variáveis como minúsculas para evitar erros na hora de digitar o código.

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#dplyr:rename

fifa2018_1 <- fifa2018 %>%
  rename(jogos_com_a_selecao = caps) #sem acento e sem espaço

```

### Filtrando e re-arranjando 

Digamos que nos interessemos em saber qual jogador tem a maior média de gols com a camisa da seleção? Ou que não queremos dados de jogadores sem gols. Como fazer?

O verbo *filter()* permite com que selecionemos apenas as entradas (linhas) que nos interessam. Para escrever corretamente, precisamos saber **exatamente** como está escrito aquilo que queremos filtrar. Para isso costumamos usar o *glimpse()* ou o *unique()*.

Vamos trabalhar no nosso banco fifa2018_1 . Quais são os times que estão em campo? Para saber os valores únicos dentro de cada coluna, usamos o *unique(nomedobanco$nomedacoluna)* : 

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#nativo:unique

unique(fifa2018_1$team)

```

Agora que vimos como está escrito, vamos filtrar os resultados para:

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#dplyr:filter

# Brasil:
brasil <- fifa2018_1 %>%
  filter(team == "Brazil")

glimpse(brasil)

# América do Sul:
america_do_sul <- fifa2018_1 %>%
  filter(team == "Brazil" | team == "Argentina" | team == "Colombia" | team == "Peru" | team == "Uruguay")

glimpse(america_do_sul)

# Jogadores do Brasil com 2 ou mais gols:
brasil2 <- fifa2018_1 %>%
  filter(team == "Brazil" & goals >=2)

glimpse(brasil2)

# Jogadores do Irã com mais de 20 anos (nascidos antes de 1998):
ira <- fifa2018_1 %>%
  filter(team == "IR Iran" & day_of_birth < "1998-01-01")

glimpse(ira)

# Apenas os jogadores que fizeram gols:
jog_gols <- fifa2018_1 %>%
  filter(goals != 0)

glimpse(jog_gols)
```


Outro modo de selecionar é com o *slice()*, que fatia a tabela, com o *select()*, que seleciona algumas colunas e com o *arrange()* , que ordena as linhas.

Vamos então selecionar apenas o nome("fifa_display_name") e a seleção("team") e os gols ("goals") dos 5 jogadores com a maior número de gols("goals"):

```{r, eval=FALSE, message=FALSE, warning=FALSE}

top5 <- fifa2018_1 %>%
  arrange(desc(goals)) %>%                # ordenando os gols em ordem decrescente
  slice(1:5) %>%                          # selecionando as 5 primeiras linhas
  select(fifa_display_name, team, goals ) #selecionando as colunas

top5
```


### Tabelas dinâmicas

No excel, é normal criarmos tabelas dinâmicas para analisarmos uma planilha. Elas agrupam e somam ou contam as entradas. Vamos aprender como fazer tabelas dinâmicas no R com o *group_by()* e o *summarise()* . 

Primeiro, vamos qual é a **soma** de gols ("goals") por time ("team") do nosso banco:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

gols_time <- fifa2018_1 %>%
  group_by(team) %>%                      # agrupando por "team"
  summarise(gols_feitos = sum(goals))     # somando os valores da coluna "goals"

gols_time
```

O *summmarise()* cria uma nova coluna. O nome é atribuído no momento da criação ("gols_feitos") e o valor da coluna é a operação que desejamos (*sum(goals)*) .

### Exercício 1:

    1. Atribua a um objeto "top_5_times" o banco "fifa2018_1", então
    2. Agrupe por time com o group_by(), então
    3. Some o número total de "goals" com o summarise(), então
    4. Ordene os gols em ordem decrescente com o arrange(), então 
    5. Selecione as 5 primeiras linhas com o slice() .

Vamos fazer um segundo exemplo com o *group_by()* e *summarise()* . Agora vamos ver a altura (height) média dos jogadores por seleçao (team):

```{r, eval=FALSE, message=FALSE, warning=FALSE}

altura_time <- fifa2018_1 %>%
  group_by(team) %>%                       # agrupando
  summarise(altura_media = mean(height))   # calculando a média das alturas 

altura_time
```

### Exercício 2:

    1 Atribua a um novo objeto o objeto "altura_time"que acabamos de criar, então 
    2. Filtre apenas o team "Brazil" com o filter(). 
    3. Qual é a altura média do time brasileiro?

Vamos fazer um terceiro exemplo com o *group_by()*, mas dessa vez para contar o número de jogadores por time. Se cada jogador é uma linha, basta contar o número de linhas que o nome do time aparece usando *n()* . Se tudo der certo, devem aparecer 23 jogadores por time:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

numero_jogadores <- fifa2018_1 %>%
  group_by(team) %>%                   # agrupando
  summarise(num_jogadores = n())       # contando o numero de linhas    

numero_jogadores

```


Vamos fazer um último exemplo? Vamos descobrir quais são os 5 clubes ("club") com mais jogadores na copa do mundo? Para isso vamos agrupar os jogadores por "club" e contar quantas vezes o clube aparece com o *n()* , por fim vamos ordenar em ordem decrescente com o *arrange()* e cortar os cinco primeiros com o *slice()* :

```{r, eval=FALSE, message=FALSE, warning=FALSE}

top_5_cubes <- fifa2018_1 %>%
  group_by(club) %>%                     # agrupando
  summarise(num_jogadores = n()) %>%     # contando o número de linhas
  arrange(desc(num_jogadores)) %>%       # ordenando em ordem decrescente
  slice(1:5)                             # cortando as 3 primeiras linhas

top_5_cubes
```

## 4. Exportar bancos de dados;

Agora que trabalhamos bastante com o objeto "fifa2018_1", está na hora de salva-lo. Vamos aprender como exportar um banco como um .csv e como uma planilha excel .xlsx .

```{r, eval=FALSE, message=FALSE, warning=FALSE}

# Tenha certeza que você vai salvar no diretório certo:
getwd()

# Exportando como csv
#library(data.table)
fwrite(fifa2018_1, file="fifa2018_1.csv")

# Exportando como excel
install.packages("xlsx") #caso você não tenha esse pacote
library(xlsx)
write.xlsx(as.data.frame(fifa2018_1), file="fifa2018_1.xlsx", row.names = FALSE)
```

**Por que precisamos colocar transformar o fifa2018_1 em dataframe?**, ele já nào era um dataframe? Sim e não. Se imprimirmos o objeto fifa2018_1 (apenas rodar o nome do objeto) veremos que ele é um objeto *tibble* . este objeto é o equivalente do dplyr ao objeto *dataframe* do R, só que ocupa menos espaço na memoria RAM e, por isso, é mais eficiente. No entanto o comando write.xlsx ainda não aceita tibles, de modo que transformamos o nosso objeto co o *as.data.frame()* .

Já o argumento *row.names = FALSE* indica que nós não queremos que o arquivo excel tenha uma coluna numerando as linhas. No default, esse comando criaria uma coluna a mais.

## 5. Juntar diferentes bancos de dados com o left_join;

Nós já importamos o banco do idh, mas vamos importar novamente para lembrar?


```{r, eval=FALSE, message=FALSE, warning=FALSE}

# Verificando qual é o diretório que está na memória
getwd()

# Se for o diretório onde está salvo o nosso arquivo, vamos importar o arquivo idh.csv com o fread, da biblioteca data.table: 

idh <- fread(file = "idh.csv")

# Olhando o banco idh
glimpse(idh)
```


Um ótimo uso para o R é poder juntar duas tabelas a partir de uma coluna em comum.
Nos dois bancos existe uma indicando o país. No banco "fifa2018_1", temos a variável "team" e no banco idh temos a variável "country". Vamos reunir os dois bancos em um com o verbo *left_join()*, também do dplyr e fazer um banco que contenha dados do idh e estatísticas de futebol.

Mas primeiro vamos olhar um exemplo generico do left_join para entender o verbo:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

# left_join(base1, base2, by = c("variavel_em_1" = "variavel_em_2"))

```

Nesse nosso exemplo fictício, *variavel_em_1* e *variavel_em_2* são as variáveis que tem ao menos algumas linhas em comum, e servirão para conectar os bancos. Vamos ver agora esse exemplo fictício aplicado ao nosso caso:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

# left_join(fifa2018_1, idh, by=c("team" = "country"))

```

Agora que entendemos a lógica do verbo, quem está à esquerda e à direita, vamos ver como escreveríamos o *left_join()* junto com o %>% e atribuindo o resultado a um objeto chamado "copa_idh".

```{r, eval=FALSE, message=FALSE, warning=FALSE}

copa_idh <- fifa2018_1 %>%
  left_join(idh, by=c("team" = "country"))

glimpse(copa_idh)
```

Como o %>% conecta os comandos, não há necessidade de apontar quem é a base da esquerda, pois ela já está indicada na primeira linha. Por isso, quando vamos usar o left_join com o %>%, só precisamos apontar qual é a base que está à direita e indicar quais são as variáveis que irão conectar os bancos. 

Agora o que que aconteceria se as duas variáveis que irão conectar os bancos tem o mesmo nome? Vamos ver no exemplo abaixo:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

copa_idh <- fifa2018_1 %>%
  rename(country = team) %>%
  left_join(idh)

glimpse(copa_idh)

```

Percebam que o número de linhas do produto final é igual ao número de linhas do dataframe da esquerda (736) . Isso acontece porque ela é o dataframe de referência. Vejamos agora o que acontece quando invertemos a ordem dos dataframes:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

idh_copa <- idh %>%
  left_join(fifa2018_1, by = c("country" = "team"))

            
```

Agora o número de linhas é 804, o mesmo número de linhas do idh.

Por fim, vamos fazer um exercício em sala para fixar os conteúdos: Vamos comparar a quantidade de gols por seleção com o IDH do país:

    1. Atribua a um novo objeto o dataframe fifa2018_1, então
    2. Agrupe os times com o group_by e calcule a soma do número de gols por time com o summarise(), então
    3. Junte com o banco do IDH com o comando left_join(), então
    3. Selecione as colunas "team", a coluna nova que você criou com o summarise ea coluna "hdi_rank_2015" com o select(), então 
    4. Ordene em ordem decrescente por número de gols com o arrange(desc()).
    5. Abra  o seu novo objeto com o View()

Chega de brincar de copa. Vamos para o mundo real?
Abra o guia da seguinda parte da aula aqui: https://github.com/voigtjessica/curso_R_ABRAJI_28062018/blob/master/aula_parte_2.rmd .
