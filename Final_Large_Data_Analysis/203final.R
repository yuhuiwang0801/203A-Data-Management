setwd("~/Desktop/203A_DataManagement/Final") 
library(haven)
library(tidyverse)
library(sas7bdat)
library(scales)

#load
hcmst <- read.sas7bdat("hcmst.sas7bdat")
casesubset <- read.csv("CaseSubset.csv")

my_case <- casesubset %>%
           filter(SUBSETNUMBER==50)
my_hcmst <- merge(hcmst,
                  my_case,
                  by="CASEID_NEW")
      
#preparing data
#trip
hc5 <- data.frame(prop.table(table(my_hcmst$Q31_5,
                                   my_hcmst$RELATIONSHIP_QUALITY),1))
hc5$Relationship_Quality <- factor(hc5$Var2, levels = c(1, 2, 3, 4, 5),
                                   labels = c("Very Poor", "Poor", "Fair", "Good", "Excellent"))

hc5 <- hc5 %>%
  arrange(Var1, desc(Relationship_Quality )) %>%
  group_by(Var1) %>%
  mutate(perclabs=cumsum(Freq))

p5 <- ggplot(hc5,aes(x=Var1,y=Freq, fill=Relationship_Quality ))+
  geom_bar(stat="identity", width=0.7) +
  geom_text(aes(y=perclabs, 
                label=ifelse(perclabs > 0.95, "", percent(perclabs))), vjust=2) +
  scale_x_discrete(limits=c("0","1"),
                   labels=c("No","Yes")) +
  labs(y="Percentage of Respondents",
       x="Met at Vacation",
       title="Relationship Quality",
       subtitle="Among those who met at vacation versus\n those who did not") 
p5

ggsave("Vacation Plot Step 2.png",
       plot=p5,
       width=5,
       height=4.5,
       units=c("in"))



#3
simulate_chi_square <- function(n1, n2, p1, p2, M, G) {
  significant_results <- numeric(G)
  
  for (i in 1:G) {
    chi_square_results <- replicate(M, {
      group1 <- rbinom(n1, 1, p1)
      group2 <- rbinom(n2, 1, p2)
      combined_data <- c(group1, group2)
      
      # Create a vector indicating the group of each observation
      group_labels <- factor(c(rep("Group1", n1), rep("Group2", n2)))
      
      # Create a contingency table
      contingency_table <- table(Group = group_labels, Data = combined_data)
      chisq_result <- chisq.test(contingency_table)$p.value
    })
    
    significant_results[i] <- sum(chi_square_results < 0.05)
  }
  
  return(significant_results)
}

# Run the function with specified inputs
n1 <- 100
n2 <- 100
p1 <- 0.2
p2 <- 0.2
M <- 20
G <- 1000
results <- simulate_chi_square(n1, n2, p1, p2, M, G)
results
# Calculate the proportion of replications with at least one significant result
proportion_significant <- mean(results > 0)

# Create a line graph with varying M values
library(ggplot2)

M_values <- 1:30
proportions <- numeric(length(M_values))

for (i in seq_along(M_values)) {
  results1 <- simulate_chi_square(n1, n2, p1, p2, M_values[i], G)
  proportions[i] <- mean(results1 > 0)
}
proportions
# Plot the line graph
ggplot(data.frame(M = M_values, Proportion = proportions), aes(x = M, y = Proportion)) +
  geom_line() +
  labs(title = "Proportion of Replications with at Least One Significant Result",
       x = "Number of Chi-Square Tests (M)",
       y = "Proportion")