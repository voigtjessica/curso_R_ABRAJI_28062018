---
title: "Como transformar vetores em datas"
author: "Jessica Voigt"
date: "26 de junho de 2018"
output: html_document
---
Datas podem vir escritas de várias formas. Vamos trabalhar com alguns exemplos fictícios.

Assim como *as.character()* e *as.numeric()*, nós temos o comando *as.Date()* - sim, com D maiúsculo - que transforma um vetor em vetor de data. No entanto, como essa data pode estar escrita de qualquer maneira, nós precisamos dizer ao R como ele deve ler. Vejamos os exemplos a seguir:

```{r, eval=FALSE, message=FALSE, warning=FALSE}

data1 <- c("15/03/1988", "23/05/1991")  # como nós escrevemos
data2 <- c("1988.03.15", "1991.05.23")  # como os americanos escrevem
data3 <- c("1988-15-03", "1991-23-05")  # alguém pode escrever assim.
data4 <- c("15/03/1988 00:00:00", "23/05/1991 00:00:00") #as vezes aparece assim

# Nos quatro casos, temos vetores de character:

class(data1)
class(data2)
class(data3)
class(data4)

# Vamos transformar esses vetores em vetores de data, dizendo ao R como ler:

data1 <- as.Date(data1, format="%d/%m/%Y") 
data1
class(data1)

#Agora para os outros objetos:

data2 <- as.Date(data2, format="%Y.%m.%d")
data2
class(data2)

data3 <- as.Date(data3, format="%Y-%d-%m")
data3
class(data3)

data4 <- as.Date(data4, format="%d/%m/%Y %H:%M:%S") 
data4    #aqui as horas desapareceram.
class(data4)
```
