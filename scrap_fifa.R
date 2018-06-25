library(tabulizer)
library(dplyr)
library(janitor)
library(xlsx)

# Jogadores da fifa
url <- 'https://tournament.fifadata.com/documents/FWC/2018/pdf/FWC_2018_SQUADLISTS.PDF'

# Extract the table
out1 <- extract_tables(url,output = "data.frame", encoding = "UTF-8")


teams <- data.frame(time = c("Argentina","Australia","Belgium","Brazil",
                             "Colombia",
                             "Costa Rica","Croatia","Denmark","Egypt",
                             "England","France", "Germany","Iceland",
                             "IR Iran","Japan","Korea Republic","Mexico",
                             "Morocco","Nigeria","Panama",
                             "Peru","Poland","Portugal","Russia",
                             "Saudi Arabia","Senegal","Serbia",
                             "Spain","Sweden","Switzerland",
                             "Tunisia","Uruguay"),
                    i =c(1:32))

i <- 1
fifa2018 <- data.frame()
y <- data.frame()
for (i in i:32) {
  
  y <- out1[[i]] %>%
    mutate(team = teams[i,1]) %>%
    clean_names() %>%
    rename(number = x)
  
  fifa2018 <- rbind(fifa2018, y)
}

# Vou exportar como excel para arrumar os erros na mão, 
# mas foi um grande avanço

write.xlsx(as.data.frame(fifa2018),
           file = "fifa2018.xlsx",
           sheetName="fifa2018")
