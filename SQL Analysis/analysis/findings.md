# Business Analysis Findings

## Question 1: High-Risk Borrower Segments

### Key Findings

* Bad loan percentage increased steadily from Grade A to Grade G, showing that lower-grade loans were more likely to default.
* **60-month loans** generally exhibited higher bad loan percentages than **36-month loans**.
* Borrowers with **Low FICO**, **High DTI**, and **RENT** home ownership showed higher bad loan percentages.
* The relationship between loan term and bad loan percentage varied across credit grades. While lower credit grades generally had higher bad loan percentages for 60-month loans,
* several higher-grade segments (Grades A–C) showed comparable or even lower bad loan percentages than their 36-month counterparts.
* This may indicate that longer-term loans for higher-quality borrowers were approved under stricter underwriting standards.

### Business Recommendation

Apply additional scrutiny to lower-grade borrowers, especially for longer-term loans and applicants with high DTI. 
The findings also suggest that the current underwriting approach for higher-grade borrowers appears to be effective.

---

## Question 2: Loan Portfolio Trend Analysis

### Key Findings

* Loan originations and total funded amounts increased significantly over the analysis period.
* Average loan amounts increased over time, while average interest rates remained relatively stable.
* The lower bad loan percentage observed in recent years should be interpreted carefully because many of those loans were still classified as **Current** and had not yet reached maturity.

### Business Recommendation

Compare portfolio performance across loan vintages with similar maturity periods. This provides a more reliable view of long-term credit performance than evaluating recently originated loans.

---

## Question 3: Geographic Distribution Analysis

### Key Findings

* California, Texas, Florida, and New York ranked among the top states for both accepted and rejected loan applications.
* Georgia ranked higher for rejected applications than accepted applications, while Illinois showed the opposite pattern.
* Comparing accepted and rejected application rankings provides better context than analyzing rejected applications alone and helps identify states that we may investigate further.

### Limitation

The accepted and rejected datasets cannot be linked at the individual application level. Therefore, this analysis compares application trends rather than approval or rejection rates.

### Performance Note

The rejected loan dataset contains approximately **27.6 million records**. If you're running this project on a machine with limited memory, consider filtering the analysis to the most recent **2–3 years** while experimenting or validating the queries.
