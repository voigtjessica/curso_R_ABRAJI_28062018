


# importando dados de municípios com biometria
biometria_dados <- fread("biometria.csv")

gilmpse(biometria_dados)
# importando dados de comparecimento para SP, MG e PE
dados_comparecimento <- fread("comparecimento.csv")

glimpse(dados_comparecimento)

## juntando os dois bancos
elec_biometria <- df %>%
  filter(DESCRICAO_CARGO == "VEREADOR") %>%
  mutate(NOME_MUNICIPIO = tolower(NOME_MUNICIPIO),
         NOME_MUNICIPIO = snakecase::to_any_case(NOME_MUNICIPIO, transliterations = c("Latin-ASCII"))) %>%
  left_join(biometria2, by=c("SIGLA_UF" = "uf" , "NOME_MUNICIPIO" = "municipio"))

## Foi preciso retirar acentos e colocar em minúscula

gilmpse(elec_biometria)

# vamos criar uma variável que diz se houve recadastro ou não no município
elec_biometria <- elec_biometria %>%
  mutate(bol_biometria = ifelse(!is.na(data), "recadastro", "sem recadastro"))

# agora, comapar abstenção nos estados selecionados em municípios com recadastro e sem recadastro
elec_biometria %>%
  group_by(SIGLA_UF, bol_biometria) %>%
  summarise(media_abstencoes = mean(QTD_ABSTENCOES),
            media_perc = round(sum(QTD_ABSTENCOES)/sum(QTD_APTOS), 2))


