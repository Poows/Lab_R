library('rvest')
library('RCurl')
library('XML')
library('stringr')

fileURL <- 'https://www.kinopoisk.ru/lists/editorial/theme_dragon/'

webpage <- read_html(fileURL)

webpage

# Ранг фильмов
rank_data <- webpage %>% html_nodes('.selection-film-item-position') %>% html_text

length(rank_data)

rank_data <- as.numeric(rank_data)

# Название фильмов
title_data <- webpage %>% html_nodes('.selection-film-item-meta__name') %>% html_text

head(title_data)

# Дата выхода фильмов
release_date <- webpage %>% html_nodes('.selection-film-item-meta__original-name') %>% html_text

head(release_date)

g <- 1
for (i in release_date) {
  year <- strsplit(i, ', ')
  year <- unlist(year)
  year <- year[length(year)]
  
  if (str_length(year) > 4) {
    year <- substring(year, 1, 4)
  } 
  vector[g] <- year
  g <- g + 1
}

release_date_vector <- as.numeric(unlist(vector))
length(release_date_vector)
head(release_date_vector)

# Страна производитель фильмов

country_date <- webpage %>% html_nodes('.selection-film-item-meta__meta-additional-item') %>% html_text

length(country_date)

vector_country_date <- rep(NA, length(country_date)/2)
i <- 1
g <- 1
while (i < length(country_date)) {
  if (!is.na(strsplit(country_date[i], ', '))) {
    country <- strsplit(country_date[i], ', ')
  }
  country <- unlist(country)
  country <- country[1]
  vector_country_date[g] <- country
  i <- i + 2
  g <- g + 1
}

head(vector_country_date)

# Оценки фильмов
rank_data_negative <- webpage %>% html_nodes('.selection-film-item-poster__rating_negative') %>% html_text
rank_data_positive <- webpage %>% html_nodes('.selection-film-item-poster__rating_positive') %>% html_text
rank_data_neutral <- webpage %>% html_nodes('.selection-film-item-poster__rating_neutral') %>% html_text
length(rank_data_negative)
length(rank_data_positive)
length(rank_data_neutral)

rank_all <- append(rank_data_negative, rank_data_positive)
rank_all <- append(rank_all, rank_data_neutral)
rank_all <- append(rank_all, NA)

head(rank_all)

# Создание таблицы
DF_movies <- data.frame(Rank = rank_data, Title = title_data,
                        Release = release_date_vector, Metascore = rank_all,
                        Country = vector_country_date)
head(DF_movies)

# Запись в .csv файл
write.csv(DF_movies, file ='./DF_movies.csv', row.names = F)
