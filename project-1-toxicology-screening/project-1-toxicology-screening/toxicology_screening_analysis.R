# Project 1: Forensic Toxicology Drug Screening
# Simulated dataset analysis

library(tidyverse)

# Load data
tox_data <- read.csv("toxicology_screening_data.csv")

# Categorise results based on analytical thresholds
tox_data <- tox_data %>%
  mutate(
    interpretation = case_when(
      concentration_ng_ml < screening_cutoff_ng_ml ~ "Below screening cutoff",
      concentration_ng_ml >= screening_cutoff_ng_ml & concentration_ng_ml < confirmation_cutoff_ng_ml ~ "Screen positive only",
      concentration_ng_ml >= confirmation_cutoff_ng_ml ~ "Confirmed positive"
    )
  )

# View summary table
print(tox_data)

# Count interpretation categories
interpretation_summary <- tox_data %>%
  count(interpretation)

print(interpretation_summary)

# Count confirmed positives by drug class
class_summary <- tox_data %>%
  filter(interpretation == "Confirmed positive") %>%
  count(drug_class, sort = TRUE)

print(class_summary)

# Plot concentrations against confirmation cutoffs
ggplot(tox_data, aes(x = substance, y = concentration_ng_ml, fill = interpretation)) +
  geom_col() +
  geom_point(aes(y = confirmation_cutoff_ng_ml), colour = "black", size = 2) +
  coord_flip() +
  labs(
    title = "Simulated Forensic Toxicology Screening Results",
    subtitle = "Bars show measured concentration; black points show confirmation cutoff",
    x = "Substance",
    y = "Concentration (ng/mL)",
    fill = "Interpretation"
  ) +
  theme_minimal()

# Save plot
ggsave("toxicology_screening_plot.png", width = 10, height = 6)
