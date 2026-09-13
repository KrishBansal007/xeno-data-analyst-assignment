# Comm-Log Send Reconciliation

## Scope

- Merchant: 501
- Period: October 2026
- Campaigns: Diwali campaigns
- Communication type: `2`
- Finance target_base: **22**

## Reconciliation Bridge

| Step | Adjustment | Result | Reason |
|---|---|---:|---|
| 1 | Naive communication-log row count | 30 | Counts every October communication-log row without applying campaign eligibility or retry/standalone rules. |
| 2 | Exclude campaign 9004 | 26 | Campaign 9004 is `approval_awaiting`, so its 4 communication-log rows are not officially reportable. |
| 3 | Apply retry-chain deduplication | 22 | Customers across a campaign and its retries represent the same underlying communication and are counted once per customer across the complete chain. |
| 4 | Validate standalone rule | 22 | Campaign 9101 is standalone, so its repeated C20 send is counted as a separate send event. This confirms why the final result is 22 rather than a global distinct-customer count of 21. |

## Final Breakdown

### Retry chain: 9001 → 9002 → 9003

The complete retry chain contains:

- Campaign 9001: C1–C10
- Campaign 9002: C2, C3
- Campaign 9003: C3

The retry attempts overlap with customers already targeted by the original campaign.

Distinct customers across the entire chain:

**10**

### Standalone campaign: 9101

Send events:

- C20 — October 10
- C20 — October 20
- C21
- C22
- C23
- C24
- C25

Campaign 9101 has no retry relationship.

Because it is standalone, every send is an individual event, including the repeated C20 send.

**Count = 7**

### Retry chain: 9201 → 9202

The complete retry chain contains:

- Campaign 9201: D1–D5
- Campaign 9202: D1

D1 appears in both campaigns, so it is counted once across the chain.

Distinct customers:

**5**

## Final Calculation

```text
Retry chain 9001–9003 = 10
Standalone campaign 9101 = 7
Retry chain 9201–9202 = 5

10 + 7 + 5 = 22