
# Define the survey questions
survey_questions <- tibble::tribble(
  ~survey_id, ~question, ~option, ~input_type, ~input_id, ~dependence, ~dependence_value, ~required,

  1, "What would you like to do? (select multiple)", "Learn about pre-regs", "checkbox", "q_intent", NA, NA, TRUE,
  1, "What would you like to do? (select multiple)", "Work on a pre-registration", "checkbox", "q_intent", NA, NA, TRUE,
  1, "What would you like to do? (select multiple)", "Report deviations after a pre-reg", "checkbox", "q_intent", NA, NA, TRUE,
  1, "What would you like to do? (select multiple)", "Assess quality of a pre-registration", "checkbox", "q_intent", NA, NA, TRUE,
  1, "What would you like to do? (select multiple)", "Find guidance on a specific field / method", "checkbox", "q_intent", NA, NA, TRUE,
  1, "What would you like to do? (select multiple)", "Convince someone / decide for myself whether to pre-register", "checkbox", "q_intent", NA, NA, TRUE,

  2, "What is your prereg expertise?", "Novice", "mc", "q_expertise", NA, NA, TRUE,
  2, "What is your prereg expertise?", "Beginner", "mc", "q_expertise", NA, NA, TRUE,
  2, "What is your prereg expertise?", "Intermediate", "mc", "q_expertise", NA, NA, TRUE,
  2, "What is your prereg expertise?", "Advanced", "mc", "q_expertise", NA, NA, TRUE,

  2, "How much time do you have?", "Hours", "mc", "q_time", NA, NA, TRUE,
  2, "How much time do you have?", "Days", "mc", "q_time", NA, NA, TRUE,
  2, "How much time do you have?", "Weeks", "mc", "q_time", NA, NA, TRUE,
  2, "How much time do you have?", "Months", "mc", "q_time", NA, NA, TRUE,

  3, "Is the study quantitative, qualitative or a literature review/meta-analysis?", "Quantitative", "mc", "q_design", NA, NA, TRUE,
  3, "Is the study quantitative, qualitative or a literature review/meta-analysis?", "Qualitative", "mc", "q_design", NA, NA, TRUE,
  3, "Is the study quantitative, qualitative or a literature review/meta-analysis?", "Literature review (incl. meta-analyses)", "mc", "q_design", NA, NA, TRUE,
  3, "Is the study quantitative, qualitative or a literature review/meta-analysis?", "Mixed-methods", "mc", "q_design", NA, NA, TRUE,

  4, "Has the data you have been using already been collected?", "Yes - but I have not accessed it yet", "mc", "q_secondary", NA, NA, TRUE,
  4, "Has the data you have been using already been collected?", "Yes - and I have already accessed it in any way", "mc", "q_secondary", NA, NA, TRUE,
  4, "Has the data you have been using already been collected?", "No", "mc", "q_secondary", NA, NA, TRUE,

  4, "Specific methods (select all that apply)", "Meta-analysis", "checkbox", "q_methods_lit", "q_design", "Literature review (incl. meta-analyses)", TRUE,
  4, "Specific methods (select all that apply)", "Systematic review", "checkbox", "q_methods_lit", "q_design", "Literature review (incl. meta-analyses)", TRUE,
  4, "Specific methods (select all that apply)", "Scoping Review", "checkbox", "q_methods_lit", "q_design", "Literature review (incl. meta-analyses)", TRUE,
  4, "Specific methods (select all that apply)", "Narrative Review", "checkbox", "q_methods_lit", "q_design", "Literature review (incl. meta-analyses)",TRUE,

  4, "Specific methods (select all that apply)", "Correlational", "checkbox", "q_methods_quant", NA, NA, TRUE,
  4, "Specific methods (select all that apply)", "Experimental", "checkbox", "q_methods_quant", NA, NA, TRUE,
  4, "Specific methods (select all that apply)", "Longitudinal", "checkbox", "q_methods_quant", NA, NA, TRUE,
  4, "Specific methods (select all that apply)", "Modeling/simulation-based research", "checkbox", "q_methods_quant",NA, NA, TRUE,
  4, "Specific methods (select all that apply)", "Clinical trial", "checkbox", "q_methods_quant", NA, NA, TRUE,

  4, "Is the research confirmatory, exploratory or a mix of both?", "Confirmatory", "mc", "q_approach", NA, NA, TRUE,
  4, "Is the research confirmatory, exploratory or a mix of both?", "Exploratory", "mc", "q_approach", NA, NA, TRUE,
  4, "Is the research confirmatory, exploratory or a mix of both?", "Mixed", "mc", "q_approach", NA, NA, TRUE,

  4, "Which of the following statements/tags applies to your research? (Select all)", "I am working in a team", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "It is replication research", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "I use code (rather than a graphical interface) for data analysis", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "Measure development", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "Psychometrics", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "Psychophysiology", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "Bayesian", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "Networks", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "SEM", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "Factor analysis", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "Missing data", "checkbox", "q_extras", NA, NA, TRUE,
  4, "Which of the following statements/tags applies to your research? (Select all)", "Neuroscience", "checkbox", "q_extras", NA, NA, TRUE
)
