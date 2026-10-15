# Data provenance and reuse

`raw/wildfires_sample_100k.csv` is the exact 100,000-row, 39-column coursework
file supplied by Elijah Chiu. SHA-256:

`4d5c250d32c77a3e522df438fc98074c21815d69536a4ea081f490dc36cfd935`

The fields and 1992–2015 date range are consistent with the fourth edition of
Karen C. Short's Fire Program Analysis Fire-Occurrence Database (FPA FOD):

Short, Karen C. 2017. *Spatial wildfire occurrence data for the United States,
1992–2015 [FPA_FOD_20170508]*, 4th edition. Fort Collins, CO: Forest Service
Research Data Archive. https://doi.org/10.2737/RDS-2013-0009.4

The exact sampling code, random seed, inclusion probabilities, download source,
and selection mechanism for this coursework extract were not supplied. This is
not a verified reproduction of a random sample from that archive. The upstream
archive is cited as the apparent parent dataset, not proof of the extract's lineage.
No new authoritative dataset was downloaded or substituted during this revision.

The Forest Service describes this database as a compilation of federal, state,
and local fire reports, with discovery date, final fire size, and location as core
fields: https://research.fs.usda.gov/treesearch/45689 . Reporting completeness is
not uniform. Even the full database would need a coverage audit before missing
county-months could safely be labeled as no-fire periods.

This repository redistributes the supplied coursework extract for reproducibility
with attribution to its apparent public federal source. The project's MIT license
does not relicense the dataset. Consult the archive's metadata and use constraints
before further redistribution or operational use. No separate license for the
coursework extract was provided, so no additional data rights are asserted here.

`COUNTY` and `FIPS_CODE` are read as text to preserve leading zeros. Missing county
values are retained because the new task does not require counties. `Shape` is the
literal placeholder `<raw>` in this CSV and is unused. Cause, containment, final
size class, incident names, administrative IDs, and reporting-system fields are
excluded from predictors; their discovery-time availability is not established or
they encode the outcome. FOD_ID is retained solely as an audit key.
