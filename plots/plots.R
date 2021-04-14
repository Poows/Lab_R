library('ggplot2')
library('rjson')
library('dplyr')
library('lattice')
library('stringr')
library('gridExtra')
library('data.table')

# График littres

data <- read.csv('./data/DF_movies.csv', header = T, sep = ',')
data

countries <- array()
for (county in strsplit(as.character(data$Country), ", ")){
  countries <- append(countries, county[1])
}

png('lattice.png', width=1000, height=1000)
xyplot(Metascore ~ Release, data = data, auto.key = list(space = 'right'),
       groups = countries,
       ylab = 'Рейтинг фильма',
       xlab = 'Дата выхода фильма',
       main = 'График разброса рейтинга от даты выхода фильма')
dev.off()

# График ggplot

fileURL <-"http://comtrade.un.org/data/cache/partnerAreas.json"
reporters <- fromJSON(file =fileURL)
is.list(reporters)

reporters <-t(sapply(reporters$results, rbind))
dim(reporters)

reporters <-as.data.frame(reporters)
head(reporters)

names(reporters) <-c('State.Code', 'State.Name.En')
reporters[reporters$State.Name.En =='Russian Federation', ]

source("https://raw.githubusercontent.com/aksyuk/R-data/master/API/comtrade_API.R")

for(i in 2010:2020) {
  Sys.sleep(5)
  s <-get.Comtrade(r = 'all', p = "643", ps = as.character(i), freq = "M",rg = '1', cc = '0207', fmt= "csv")
  
  file.name <-paste('./data/comtrade_', i, '.csv', sep ='')
  
  write.csv(s$data, file.name, row.names =F)
  
}

df <- read.csv('./data/comtrade_2010.csv', header = TRUE, sep = ',')
for (i in 2011:2020){
  # Считываем данные из .csv файла
  df.temp <- read.csv(paste('./data/comtrade_', i, '.csv', sep=''), header = T, sep=',')
  # Заполняем основной дата фрейм
  df <- rbind(df, df.temp)
}

df <- df[, c(2, 4, 10, 30, 32)]
df_test <- df
df <- data.table(df)


df <- df[, Netweight..kg. := as.double(Netweight..kg.)]

df[, round(mean(.SD$Netweight..kg., na.rm = T), 0), by = Year]

df[, Reporter, Year]
df_test[, "Partner"]

df[, Netweight..kg..mean := round(mean(.SD$Netweight..kg., na.rm = T), 0), by = Year]
df[!is.na(Netweight..kg.), Netweight..kg..mean := Netweight..kg.]
df[is.na(Netweight..kg.), Year, Netweight..kg..mean]

new.df <- data.frame()
new.df <- rbind(new.df, cbind(df[(df$Year < 2014) | (df$Year > 2014), ], C_Year = '!2014'))
new.df <- rbind(new.df, cbind(df[df$Year == 2014, ], C_Year = '==2014'))
dim(new.df)
new.df

png('ggplot.png', width = 1000, height= 1000)
ggplot(data = new.df, aes(x = C_Year, y = Netweight..kg..mean, group = C_Year, color = C_Year)) +
  geom_boxplot() +
  scale_color_manual(values = c('red', 'blue', 'green'),
                     name = "Группы стран-поставщиков:") +
  labs(title = 'Коробчатые диаграммы суммарной массы поставок',
       x = 'Страны', y = 'Масса')
dev.off()
