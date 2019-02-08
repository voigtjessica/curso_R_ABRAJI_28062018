---
title: "Introdução ao R para Jornalistas - Parte 2"
author: "Manoel Galdino e Jessica Voigt"
date: "12 de junho de 2018"
output: html_document
---

## 6. Aplicando o que aprendemos ao mundo real.

Vamos agora trabalhar com um problema real?
Vamos comparar o número de abstenções em eleições com a taxa do recadastramento biométrico. A ideia aqui é verificar se essas duas variáveis (abstenção e recadastramento) podem estar relacionadas. Vamos utilizar dados das últimas eleições do TSE. 

    1. Vá em https://goo.gl/UaLsjz  e baixe os arquivos "biometria.csv" e "comparecimento.csv" ;
    2. Salve em uma pasta conhecida. 

Verifique se o seu diretório está no lugar correto com o *getwd()* e, caso não esteja, redefina-o com o *setwd()*.
    
Vamos importar os dois arquivos.csv com o *fread()*:

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#data.table:fread
#dplyr:glimpse

# importando dados de municípios com biometria
biometria_dados <- fread("biometria.csv")
glimpse(biometria_dados)

# importando dados de comparecimento para SP, MG e PE
dados_comparecimento <- fread("comparecimento.csv")
glimpse(dados_comparecimento)

```


Vamos verificar o grau de abstenções baseado nas eleições municipais do banco dados_comparecimento. Para isso vamos filtrar a DESCRICAO_CARGO = "VEREADOR" e ai juntar com os dados de abstenção.

Reparem: colocamos o filter, teremos apenas **um município por linha**, de modo que podemos dizer que **cada observação corresponde a um município**.

Por fim, o "NOME_MUNICIPIO" no banco dados_comparecimento está em caixa alta e acentuada, o que para o R significa dizer que é diferente do que está na coluna "municipio" do banco biometria_dados. Além disso, os município no banco biometria_dados estão separados com _ , e no banco dados_comparecimento não estão.
Então, vamos ter que sobrescrever a coluna NOME_MUNICÍPIO com valores em caixa-baixa, sem acento e substituir os espaços por _ . Para isso utilizaremos o *mutate()* junto com as funções nativas *tolower()* , *iconv()* e *gsub()*e, só então, poderemos usar o *left_join()* para juntarmos os dois bancos:

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#nativo:tolower
#nativo:iconv
#nativo:gsub
#dplyr:filter
#dplyr:mutate
#dplyr:left_join

elec_biometria <- dados_comparecimento %>%
  filter(DESCRICAO_CARGO == "VEREADOR") %>%
  mutate(NOME_MUNICIPIO = tolower(NOME_MUNICIPIO),
         NOME_MUNICIPIO = iconv(NOME_MUNICIPIO, to="ASCII//TRANSLIT"),
         NOME_MUNICIPIO = gsub(" ", "_", NOME_MUNICIPIO))  %>%
  left_join(biometria_dados, by=c("SIGLA_UF" = "uf" , "NOME_MUNICIPIO" = "municipio"))
```

O *iconv()* converte vetores de texto entre diferentes encodings. O que precisamos saber aqui é que quando convertemos para "ASCII//TRANSLIT" estamos, na prática, retirando os acentos.

Observação: As vezes, por alguma codificação de localidade, o iconv() não funciona. Nesses casos, é possível usar a função stri_trans_general() do pacote "stringi" . Exemplo: NOME_MUNICIPIO = stri_trans_general(NOME_MUNICIPIO, "Latin-ASCII") .
 
Percebam também que o *left_join()* está juntando os bancos com base em dois critérios: uf e município. Fazemos isso pois existem municípios com o mesmo nome em estados diferentes. 

Vamos ver como está o nosso banco agora:

```{r, eval=FALSE, message=FALSE, warning=FALSE}
glimpse(elec_biometria)
```

Percebam que as colunas "data" e "eleitores" estão cheias de colunas vazias (*NA*) . Por que que isso acontece?

Quando o banco da esquerda possuem colunas que não dão match com o banco da direita, então as colunas importadas do banco da direita, nessas linhas, ficam vazias. 

No nosso caso, **as linhas das colunas "data" e "eleitores" que não estão vazias são aquelas cuja cidade (linha) teve recadastramento biométrico**.

Agora vamos sobrescrever o banco elec_biometria , criando uma nova coluna que responderá de uma forma ou de outra, dependendo da condição que a gente dá usando o *if_else()* do pacote dplyr(como o SE no Excel). Vejamos primeiro um exemplo:

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#if_else(condição, resultado_se_verdadeiro, resultado_se_falso)
```

Simples, não?
Agora vamos aplicar no nosso caso:

```{r, eval=FALSE, message=FALSE, warning=FALSE}
#dplyr:if_else

elec_biometria <- elec_biometria %>%
  mutate(situacao_recadastramento = if_else(!is.na(data), "recadastro", "sem recadastro"))

```

*Crie a coluna bol_biometria com os valores: Se data não é NA* - !is.na(data) - *então escreva "recadastro", senão escreva "sem recadastro"*.

Viu? Criamos uma variável para explicar quando aparece e quando não aparece o NA.


######Obs: existe uma função *ifelse()* nativa, mas ela apresenta problemas quando aplicamos para variáveis de datas. Por isso, eu particularmente prefiro o uso do *if_else()* do dplyr. Fora esse detalhe, as duas funções operam da mesma maneira.

Agora vamos comparar as abstenções com o recadastramento biométrico. Usando o *group_by()* vamos agrupar duas variáveis: estado (SIGLA_UF) e a situação do recadastramento (situacao_recadastramento). 
Depois de agrupadas, vamos obter a média de abstenções (QTD_ABSTENCOES) com o percentual de abstenções em relação à quantidade de pessoas aptas à votar (QTD_APTOS) usando o *summarise()*

```{r, eval=FALSE, message=FALSE, warning=FALSE}
elec_biometria_final <- elec_biometria %>%
  group_by(SIGLA_UF, situacao_recadastramento) %>%
  summarise(media_abstencoes = mean(QTD_ABSTENCOES),
            media_perc = round(sum(QTD_ABSTENCOES)/sum(QTD_APTOS), 2))

elec_biometria_final
```

Quais conclusões podemos tirar?

 
## 7. Tidyr:: gather() e spread() 

Por fim, vamos aprender como usar as funções gather() e spread() do pacote tidyr.

Primeiro, como vocês já sabem, vamos instalar o pacote:
```{r, eval=FALSE, warning=FALSE, message=FALSE}

#instalando o pacote
install.packages("tidyr")

#ativando a biblioteca
library(tidyr)

```

Agora vamos olhar o objeto elec_biometria_final que acabamos de criar?

```{r, eval=FALSE, warning=FALSE, message=FALSE}

elec_biometria_final

```

Os estados se repetem duas vezes: uma para situação sem recadastro e outra para a situação com recadastro. Talvez não seria melhor que sem recadastro e com recadastro forrem duas colunas, e não linhas, de forma que cada linha (observação) pudesse ser um estado? Podemos ter uma tabela com sigla, média percentual sem recadastro e média percentual com recadastro.

Podemos "transpor" as linhas para colunas de uma forma segura com o spread() , ou seja, espalhar o que está em uma linha em várias colunas:

```{r, eval=FALSE, warning=FALSE, message=FALSE}

#tidyr:spread

elec_biometria_final  %>%
  select(-media_abstencoes) %>%                  #tirando a coluna que não nos interessa
  spread(situacao_recadastramento, media_perc)   
#espalhe o que está na coluna situacao_recadastramento em outras colunas e preencha com o conteúdo da coluna media_perc.
```

Vejam como ficou!

Vamos fazer esse exemplo novamente, agora utilizando a media_abstencoes para entendermos o que aconteceu:

```{r, eval=FALSE, warning=FALSE, message=FALSE}

elec_biometria_final  %>%
  select(-media_perc) %>%                 
  spread(situacao_recadastramento, media_abstencoes) 
#espalhe o que está na coluna situacao_recadastramento em outras colunas e preencha com o conteúdo da coluna media_abstencoes.
```

Agora os números que preenchem as colunas recadastro e 'sem recadastro' os valores das abstenções nos estados.

Vamos agora atribuir a um novo objeto o resultado da nossa primeira operação, aquela que "spredou" a variável situacao_recadastramento e preencheu com os valores da media_perc.

```{r, eval=FALSE, warning=FALSE, message=FALSE}

tabela <- elec_biometria_final  %>%
  select(-media_abstencoes) %>%              
  spread(situacao_recadastramento, media_perc)  

```

Digamos então que, depois de usar o nosso objeto tabela, queremos que as colunas recadastro e 'sem recadastro' voltem a ser linhas. Para isso, devemos usar o verbo gather().

Vamos ver primeiro os argumentos dele em português?

```{r, eval=FALSE, warning=FALSE, message=FALSE}
#tidyr:gather()

# banco %>% 
#   gather(coluna_que_agrupa_colunas, coluna_que_recebe_valores, coluna1, coluna2)

```

O que que isso quer dizer?

1. O meu primeiro argumento é o banco(*data*), mas ele já está dito, porque usamos o pipe;
2. O segundo argumento é o nome que eu vou dar a coluna que vai receber as colunas que vou agrupar (*key*);
3. O terceiro argumento e o nome que eu vou dar a coluna que vai receber os valores que originalmente estavam embaixo das colunas que eu agrupei (*value*);
4. O quarto argumento em diante são as colunas que eu vou agrupar.

Vamos agora olhar esse exemplo na prática?

```{r, eval=FALSE, warning=FALSE, message=FALSE}

tabela %>%
  gather(situacao_recadastramento, media_perc, recadastro, `sem recadastro`)

#como a coluna sem recadastro tem um espaço, eu preciso escreve-la com aspas simples ''
```

Viram? 

Essa função é muito útil quando o nosso banco está "curto"  e precisamos de um banco "longo" para gerar gráficos.


***
> Considerações finais:

Espero que tenham gostado da aula de hoje. Esses tutoriais estarão sempre disponíveis para que vocês possam consultar futuramente e aplicar o que vocês aprenderam ao cotidiano de vocês. 

Por fim, algumas dicas:

* Stackoverflow : Caso tenha dúvidas de como funciona um determinado comando ou fazer uma operação, consulte o site https://pt.stackoverflow.com/ . Sempre pergunte mencionando a linguarem que você está utilizando, no caso R .
* Veja o [Dplyr Cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) para nunca mais errar comandos com o dplyr .
* Consulte rapidamente o que cada join faz [com essa imagem](https://goo.gl/nQkfCw) .
* Caso outras dúvidas sobre a aula de hoje venham a aparecer, escreva para jvoigt@transparencia.org.br ou mgaldino@transparencia.org.br

### Até a próxima!
