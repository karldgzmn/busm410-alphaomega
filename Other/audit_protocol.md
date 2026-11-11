# Audit Protocol

- The agent proposes one short BigQuery query at a time. Karl reviews the query and approves it before it runs.
- Karl confirms the source table and columns in BigQuery and shares the results used in the analysis. The agent cites sources for data claims and labels its own conclusions.
- Before settling on a gap, the agent checks date coverage, repeated keys, missing values, and impossible values in the fields used. Karl reviews the query results and the assumptions behind the comparison and estimate.
- The agent proposes substantial human audit-log entries with a category. Karl approves each entry before it is added.
- The agent never invents checks, sources, results, or work by the other partner. Unresolved questions stay marked as unresolved.
