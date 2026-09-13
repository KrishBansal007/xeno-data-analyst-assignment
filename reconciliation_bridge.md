# Comm-Log Send Reconciliation

## Scope

- Merchant: 501
- Period: October 2026
- Campaigns: Diwali campaigns
- Communication type: `2`
- Finance target_base: **22**

## Reconciliation Bridge

| Step | Adjustment | Count | Reason |
|---|---|---:|---|
| 1 | Naive communication-log row count | 30 | Counts every October communication-log row without applying campaign eligibility or retry/standalone rules. |
| 2 | Exclude campaign 9004 | 26 | Campaign 9004 is `approval_awaiting`, so its 4 log rows are not officially reportable even though sends exist in the log. |
| 3 | Collapse retry chains | 20 | Customers reached through a campaign and its retries represent the same underlying communication and must be counted once per distinct customer. |
| 4 | Restore repeated standalone send | 22 | Campaign 9101 is standalone, so its repeated C20 send is a separate send event and must be counted twice. |

## Final Calculation

### Retry chain: 9001 → 9002 → 9003

10 distinct customers:

- C1
- C2
- C3
- C4
- C5
- C6
- C7
- C8
- C9
- C10

**Count = 10**

The retries do not create additional target-base customers because the same underlying communication is being retried.

### Standalone campaign: 9101

Send events:

- C20 — October 10
- C20 — October 20
- C21
- C22
- C23
- C24
- C25

Because 9101 is standalone, each send is an individual event.

**Count = 7**

### Retry chain: 9201 → 9202

Distinct customers:

- D1
- D2
- D3
- D4
- D5

**Count = 5**

### Final target_base

```text
10 + 7 + 5 = 22