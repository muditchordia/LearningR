# Here is an example of conflict
library(tidyverse)
library(NHANES)

# R basics ---------------------------------------------------------------

weight_kilos <- 100
weight_kilos <- 10

weight_kilos

colnames(airquality)
str(airquality)
summary(airquality)
2 + 2

# Packages ----------------------------------------------------------------

library(tidyverse)
help()

# This will be used for testing out Git

# Looking at data ---------------------------------------------------------

glimpse(NHANES)
colnames(NHANES)

select(NHANES, Age, Weight, BMI)
select(NHANES, -HeadCirc)
select(NHANES, starts_with("BP"))
select(NHANES, ends_with("Day"))
select(NHANES, contains("Age"))

nhanes_small <- select(
  NHANES,
  Age,
  Gender,
  BMI,
  Diabetes,
  PhysActive,
  BPSysAve,
  BPDiaAve,
  Education
)
nhanes_small


# Fixing variable names ---------------------------------------------------

nhanes_small <- rename_with(
  nhanes_small,
  snakecase::to_snake_case
)

nhanes_small <- rename(nhanes_small, sex = gender)

nhanes_small


# Piping ------------------------------------------------------------------

colnames(nhanes_small)

nhanes_small %>%
  colnames()

nhanes_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)


# Exercise 7.8 ------------------------------------------------------------

nhanes_small %>% select(bp_sys_ave, education)
nhanes_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )

nhanes_small %>%
  select(bmi, contains("Age"))

nhanes_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)

nhanes_small

# Filtering Rows ----------------------------------------------------------

nhanes_small %>%
  filter(phys_active != "No")

nhanes_small %>%
  filter(bmi >= 25 &
    phys_active == "No")

nhanes_small %>%
  filter(bmi >= 25 |
    phys_active == "No")


# Arranging rows ----------------------------------------------------------

nhanes_small %>%
  arrange(desc(age), bmi, education)

# Mutating columns --------------------------------------------------------

nhanes_small %>%
  mutate(
    age_month = age * 12,
    logged_bmi = log(bmi),
    age_weeks = age_month * 4,
    old = ifelse(
      age >= 30,
      "old",
      "young"
    )
  )


# Exercise 7.12 -----------------------------------------------------------


nhanes_small %>%
  filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

nhanes_modified <- nhanes_small %>%
  mutate(
    mean_arterial_pressure = ((2 * bp_dia_ave) + bp_sys_ave) / 3,
    young_child = ifelse(
      age < 6, "yes", "no"
    )
  )
nhanes_modified


# Summarizing -------------------------------------------------------------

nhanes_small %>%
  filter(!is.na(diabetes)) %>%
  group_by(
    diabetes,
    phys_active
  ) %>%
  summarize(
    max_bmi = max(bmi, na.rm = "TRUE"),
    min_bmi = min(bmi, na.rm = "TRUE")
  ) %>%
  ungroup()

write_csv(
  nhanes_small,
  here::here("data/nhanes_small.csv")
)
