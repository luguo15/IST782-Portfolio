# ist 719 hw6
# lguo15@syr.edu
# ist 719 hw6
# lguo15@syr.edu
################################################################################
# 1. Load the data set and create a new data frame
df <- read.csv("/Users/guolu/Library/CloudStorage/OneDrive-SyracuseUniversity/IST719/week11/data_cleaned_2021.csv")
library(ggplot2)
library(maps)
library(tidyverse)
# install.packages("ggridges")
library(ggridges)
library(reshape2)
library(dplyr)
library(ggbeeswarm)
library(ggthemes)

df$Size <- factor(df$Size, levels = c('1 - 50 ', '51 - 200 ', '201 - 500 ', '501 - 1000 ', '1001 - 5000 ', '5001 - 10000 ', '10000+ '))
################################################################################
# Data preprocess
# aggregate the data by company size, then calculate the sum of each skill

df_skills <- df %>%
  filter(!is.na(Size)) %>%
  group_by(Size) %>%
  summarise(Python = mean(Python),
            Excel = mean(excel),
            SQL = mean(sql),
            Spark = mean(spark),
            AWS = mean(aws),
            Tableau = mean(tableau),
            Scikit = mean(scikit))

df_skills_proportion <- df %>%
  filter(!is.na(Size)) %>%
  summarise(Python = mean(Python),
            Excel = mean(excel),
            SQL = mean(sql),
            Spark = mean(spark),
            AWS = mean(aws),
            Tableau = mean(tableau),
            Scikit = mean(scikit))

df_skills_melt <- melt(df_skills, id.vars = "Size", variable.name = "Skill", value.name = "Proportion")

df_rating <- df[df["Rating"] != -1,] %>% filter(!is.na(Size))

# Create a job title dataframe
df_title <- df[df$Job.Titles %in% c("data scientist", "analyst", "data engineer"),]

df_title_skills <- df_title %>%
  group_by(Job.Titles) %>%
  summarise(Python = mean(Python),
            Excel = mean(excel),
            SQL = mean(sql),
            Spark = mean(spark),
            AWS = mean(aws),
            Tableau = mean(tableau),
            Scikit = mean(scikit))
df_title_melt <- melt(df_title_skills, id.vars = "Job.Titles", variable.name = "Skill", value.name = "Proportion")

################################################################################
# Picture 1
# create a histogram of the variable "Avg.Salary.K." using the hist() function
hist(df$Avg.Salary.K., main = "Histograme of Average Salary (K)", xlab = "Average Salary (K)", ylab = "Frequency", col = "#C0DEFF",
     ylim = c(0,200), xlim = c(0,270))
################################################################################
# Picture 2
# create a histogram of the variable "Rating"
hist(df_rating$Rating, main = "Distribution of Rating", xlab = "Rating", ylab = "Frequency", col = "#C0DEFF")
################################################################################
# Picture 3--old
# Average Salary by Company Size
# create a boxplot to compare the variable "Avg.Salary.K." by the variable "Size" using the boxplot() function
boxplot(Avg.Salary.K. ~ Size, data = subset(df, Size != "unknown"),
        main = "Average Salary by Company Size", xlab = "Company Size", ylab = "Average Salary (K)",
        col = "#C4DDFF")
abline(h = mean(df$Avg.Salary.K.), lty = 1, col = "#FFE5F1", lwd = 2)


################################################################################
# Picture 4
# map--Job Numbers by State
# map

# Aggregate job numbers by state abbreviation
job_number <- aggregate(index ~ Job.Location, data = df, FUN = length)
colnames(job_number) <- c("abbstate", "job_num")

# Get full state names from state.abb and state.name datasets
state_names <- data.frame(state = state.abb, name = state.name)

# Merge state names with job numbers
job_numb <- merge(job_number, state_names, by.x = "abbstate", by.y = "state")

# Create a new column to store the lowercase state name, and column name is "region"
job_numb$region <- tolower(job_numb$name)

# Rename the job_num column to match the column name in state_map
colnames(job_numb)[which(colnames(job_numb) == "job_num")] <- "job_num"

# Get map data for US states
state_map <- map_data("state")

# Merge job numbers with map data
state_map <- merge(state_map, job_numb, by = "region", all.x = TRUE)
state_map <- state_map %>% arrange(order)

# Draw map--Job Numbers by State
ggplot(state_map, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = job_num), color = "white") +
  scale_fill_gradient(low = "#D2DAFF", high = "#3E54AC", na.value = "#EEF1FF") +
  coord_fixed(1.3) +
  theme_void() +
  theme(legend.position = "bottom") +
  labs(title = "Job Numbers by State")


################################################################################
# Picture 5-- Skills required by companies of different sizes(Group by skill)
skill_colors <- c("Python" = "#7FB5FF",
                  "Spark" = "#C0DEFF",
                  "AWS" = "#97C4B8",
                  "Excel" = "#CCF3EE",
                  "SQL" = "#ADA2FF",
                  "Tableau" = "#E5E0FF",
                  "Scikit" = "#FFE6E6")

# Does different size of company requirement different skills?
ggplot(df_skills_melt, aes(x = Size, y = Proportion, fill = Skill)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Size", y = "Proportion of Companies", fill = "Skill") +
  ggtitle("Skills required by companies of different sizes") +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = skill_colors) +
  theme_minimal()

################################################################################
# Picture 6 -- Skills required by different job title (Group by job title)
title_colors <- c("data scientist" = "#C0DEFF", "analyst" = "#E5E0FF", "data engineer" = "#FFFFD0")

ggplot(df_title_melt, aes(x = Job.Titles, y = Proportion, fill = Skill)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Job.Titles", y = "Proportion of Companies", fill = "Skill") +
  ggtitle("Skills required by different job title") +
  theme(legend.position = "bottom")+
  scale_fill_manual(values = skill_colors) +
  theme_minimal()

################################################################################

# Picture 7--job title salary density plot
# Set colors
title_colors <- c("data scientist" = "#C0DEFF", "analyst" = "#E5E0FF", "data engineer" = "#FFFFD0")

# Create a job title salary density plot
ggplot(df_title, aes(x = Avg.Salary.K., y = Job.Titles, fill = Job.Titles)) +
  geom_density_ridges(
    point_shape = "|", point_size = 2, size = 0.25,
    position = position_points_jitter(height = 0), alpha = 0.6, scale = 1.6
  ) +
  stat_density_ridges(quantile_lines = TRUE, quantiles = 2) +
  scale_fill_manual(values = title_colors)+
  theme_classic()
################################################################################

# Picture 8--job title salary density plot
# Create a job title dataframe
# Set colors
# Create a job title salary density plot
size_colors <- c("#7FB5FF",
                 "#C0DEFF",
                 "#97C4B8",
                 "#CCF3EE",
                 "#ADA2FF",
                 "#E5E0FF",
                 "#FFE6E6")
ggplot(df_rating, aes(x = Rating, y = Size, fill = Size)) +
  geom_density_ridges(
    point_shape = "|", point_size = 2, size = 0.25,
    position = position_points_jitter(height = 0), alpha = 0.6, scale = 1.6
  ) +
  stat_density_ridges(quantile_lines = TRUE, quantiles = 2) +
  scale_fill_manual(values = size_colors)+
  theme_classic()

################################################################################
# Picture 9
library(ggplot2)

# make sample dataframe

Category <- c("Python",
              "Excel",
              "SQL",
              "AWS",
              "Spark",
              "Tableau",
              "Scikit")
Percent <- c(53, 52, 52, 24, 23, 20, 7)


internetImportance<-data.frame(Category,Percent)

# append number to category name
internetImportance$Category <-
  paste0(internetImportance$Category," - ",internetImportance$Percent,"%")

# set factor so it will plot in descending order 
internetImportance$Category <-
  factor(internetImportance$Category, 
         levels=rev(internetImportance$Category))


ggplot(internetImportance, aes(x = Category, y = Percent,
                               fill = Category)) + 
  geom_bar(width = 0.9, stat="identity") + 
  coord_polar(theta = "y") +
  xlab("") + ylab("") +
  ylim(c(0,100)) +
  ggtitle("Skills Required Proportion") +
  geom_text(data = internetImportance, hjust = 1, size = 3,
            aes(x = Category, y = 0, label = Category)) +
  theme_void() +
  theme(legend.position = "none",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank())

################################################################################
# plot 10
my.cols <- c("#FFE5F1","#2F2F9F","#ADA2FF", "#97C4B8","#E5E0FF","#171779","#9D9DD7", "#5555AF", "#07074F")
p.beeswarm <- ggplot(df) + aes(x = Type.of.ownership, y = Avg.Salary.K., color=Type.of.ownership) + 
  geom_beeswarm() +
  scale_color_manual(values=my.cols) +
  theme_tufte()
p.beeswarm


################################################################################
# not Used
# Plot 1
# ggplot(df_skills, aes(x = Size)) +
#   geom_line(aes(y = pct_python, color = "Python", group = 1)) +
#   geom_line(aes(y = pct_spark, color = "Spark", group = 1)) +
#   geom_line(aes(y = pct_aws, color = "AWS", group = 1)) +
#   geom_line(aes(y = pct_excel, color = "Excel", group = 1)) +
#   geom_line(aes(y = pct_sql, color = "SQL", group = 1)) +
#   geom_line(aes(y = pct_tableau, color = "Tableau", group = 1)) +
#   geom_line(aes(y = pct_scikit, color = "Scikit", group = 1)) +
#   labs(x = "Size", y = "Percentage of Skills") +
#   scale_color_manual("", values = c("Python" = "#001D6E",
#                                     "Spark" = "blue",
#                                     "AWS" = "#7FB5FF",
#                                     "Excel" = "#7286D3",
#                                     "SQL" = "#8EA7E9",
#                                     "Tableau" = "#E5E0FF",
#                                     "Scikit" = "#FFF2F2")) +
#   theme_minimal()


# Plot 2
# create a barchart of the variable "Location" using the table() and barplot() functions
# barplot(table(df$Job.Location), main = "Barplot of Workplace Location", xlab = "Location", ylab = "Frequency",
#         col = "lightgreen", ylim = c(0,160))
# 
# # PLot3 
# plot(density(df$Rating), main = "Density plot of Rating", xlab = "Rating", ylab = "Density",
#      col='darkred',lwd=3)

# Plot 4 -- Skills required by companies of different sizes (Group by size)

ggplot(df_skills_melt, aes(x = Skill, y = Proportion, fill = Size)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Skill", y = "Proportion of Companies", fill = "Size") +
  ggtitle("Skills required by companies of different sizes") +
  theme(legend.position = "bottom")+
  scale_fill_manual(values = size_colors) +
  theme_minimal()

#plot 5
boxplot(Avg.Salary.K. ~ Type.of.ownership, data = df,
        main = "Average Salary by Company Type", xlab = "Company Type", ylab = "Average Salary (K)",
        col = "#C4DDFF")
abline(h = mean(df$Avg.Salary.K.), lty = 1, col = "#FFE5F1", lwd = 2)



# Picture 3--new
# Average Salary by Company Type
# create a boxplot to compare the variable "Avg.Salary.K." by the variable "" using the boxplot() function

ggplot(df, aes(x = Type.of.ownership, y = Avg.Salary.K.)) +
  geom_boxplot(fill = "#C4DDFF") +
  labs(title = "Average Salary by Company Type",
       x = "Company Type",
       y = "Average Salary (K)")+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        axis.title.x = element_blank())+
  geom_hline(yintercept = mean(df$Avg.Salary.K.), linetype = "dashed",col = "#FFE5F1")






