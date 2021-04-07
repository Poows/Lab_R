library('RCurl')
library('XML')

data.dir <- './data'

if (!file.exists(data.dir)) dir.create(data.dir)

log.filename <- '.data/download.log'

if (!file.exists(log.filename)) dir.create(log.filename)

fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/COMTRADE/040510-Imp-RF-comtrade.csv'
dest.file <-'./data/040510-Imp-RF-comtrade.csv'

if (!file.exists(dest.file)) {
  download.file(fileURL, dest.file)
  
  write(paste('Файл', dest.file, 'загружен', Sys.time()), file = log.filename, append = T)
}

if (!exists('DF.import')) {
  DF.import <-read.csv(dest.file, stringsAsFactors =F) 
}

dim(DF.import)
str(DF.import)
head(DF.import)
tail(DF.import)

fileURL <-'https://www.w3schools.com/xml/simple.xml'
doc <- getURI(fileURL)

parsedXML <- xmlTreeParse(doc, useInternalNodes = T)

rootNode <- xmlRoot(parsedXML)

xmlName(rootNode)

names(rootNode)

rootNode[[1]][[1]]

xmlValue(rootNode[[1]][[1]])

values.all <- xmlApply(rootNode, xmlValue)

values.all[1:2]

xpathSApply(rootNode, '//*', xmlValue)

xpathSApply(rootNode, '//price', xmlValue)

xpathSApply(rootNode, '//calories', xmlValue)

DF.food <- xmlToDataFrame(rootNode, stringsAsFactors = F)

head(DF.food)

# Пример 3

fileURL <-'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'
xmlData <-getURL(fileURL)
parsedXML <-xmlParse(xmlData, useInternalNodes =T)
rootNode <-xmlRoot(parsedXML)
class(rootNode)
xmlName(rootNode)

tag <-xpathSApply(rootNode, "//*", xmlName)
tag <-unique(tag)
length(tag)
tag

try.tag <-xpathSApply(rootNode, "//name", xmlValue) 
try.tag
try.tag <-xpathSApply(rootNode, "//gesmes:name", xmlValue)  # тег найден
try.tag

xmlNamespace(rootNode)

tag <-xpathSApply(rootNode, "//*[name()='Cube'][@currency]", xmlGetAttr, 'currency')
tag

curr.names <-unlist(tag)
