---
title: "Como instalar o R?"
author: "Jessica Voigt"
date: "26 de junho de 2018"
output: html_document
---

#### Windows e Mac

Para instalar o R:

1. Vá até a página [https://www.r-project.org/](https://www.r-project.org/);
2. Clique em "CRAN" no canto superior esquerdo;
3. Escolha um servidor para transferência do programa;
4. Selecione o sistema operacional do seu computador;
5. Escola o subdiretório "base";
6. Clique no arquivo cuja descrição é "Setup program";
7. Instale o R com a "instalação completa";

Para instalar o RStudio:

1. Vá em [https://www.rstudio.com/products/rstudio/download/] (https://www.rstudio.com/products/rstudio/download/)
2. Escolha a versão *free*

#### Linux:

Para instalar o R:

1. Digite no prompt os comandos:

> sudo apt-get update
  sudo apt-get install r-base-core

Para instalar o RStudio:

1. Faça o download do programa em [https://www.rstudio.com/products/rstudio/download/] (https://www.rstudio.com/products/rstudio/download/);
2. Instale as bibliotecas ”libssl0.9.8″, “libapparmor1” e “apparmor-utils” com os comandos:
    
> apt-get install libssl0.9.8 libapparmor1 apparmor-utils

3. Instale o RStudio:
     
> sudo dpkg -i rstudio-0.97.551-i3862.deb
