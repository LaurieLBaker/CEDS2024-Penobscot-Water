---
date: "2022-04-25 T00:00:00Z"
external_link: ""
image:
  caption: "Aerial View of the Penobscot. The river with the double curve. Photo from Angie Reed"
  focal_point: Smart
links:
- icon: twitter
  icon_pack: fab
  name: Follow
  url: 
slides: 
summary: 
tags:
- Water Monitoring
- Quality Control
- Reports
title: Monitoring Water Quality in the Penobscot River
publishDate: "2022-04-25T00:00:00Z"
url_code: ""
url_slides: ""
url_video: ""
---


## Project Background

## Project Outputs

<figure>
    <img src="/img/lab_report_ex.png"
         alt="Example Lab Report">
    <figcaption>Figure 3. Example water quality lab report.</figcaption>
</figure>

Our project focused on revamping the field and lab reports used by PNWRP. The original field report, created in Microsoft Access, contained various data about the site visit, sample details, and collection tools. Our community partners requested a more navigable report with quality control flags and the ability to auto-generate reports by changing the collector’s initials.

We enhanced the field report by introducing tabs for easy navigation across different report sections. Each tab contains 3 to 4 tables with relevant data. Tables like ‘Water Temperature and DO’ include a filter section for easy data sorting. Users can also adjust the number of rows and column order. We incorporated control flags in the sample information section, using green to indicate samples collected correctly and red for those that didn’t follow the protocol. This streamlined report design ensures clarity and ease of use for the reader. Furthermore, the table of contents displays the collection dates for all samples. Upon selecting a date, additional header sections unfold, revealing the associated run code and site code. This interactive feature enhances the report’s usability, allowing users to access specific information swiftly.


[IMAGE OR VIDEO OF THE FIELD REPORT]

Secondly, we dedicated the last half of the term to creating a lab report that would contain similar quality control flags as before, but in this case, it will flag any samples that have exceeded the recommended holding time for the sample before being analyzed. There are around 10 constituents, and each has a different recommended holding time for the most optimized results. This report also contains the filtering and sorting features as the field report. Our last iteration separated each sampling visit by constituents, per our community partners' request, and instead of having the results for all the constituents, they appear as headers in the table of contents for a more seamless transition between different lab reports. 

[IMAGE OR VIDEO OF THE LAB REPORT] TBD

In the latter half of the term, we focused on developing a lab report with quality control flags similar to the field report. However, these flags were designed to highlight samples exceeding their recommended holding time before analysis. With approximately 10 constituents, each with a unique optimal holding time, this feature ensures the most accurate results.

Like the field report, this lab report also includes filtering and sorting capabilities. In our final iteration, we tailored the report to our community partners’ needs by organizing each sampling visit by the constituent. Instead of displaying results for all constituents together, they are presented under separate headers in the table of contents, facilitating a smoother transition between different lab reports.


## Team

During the Spring of 2024, Cedar Callaghan ’25, Linnea Goh ’25, and Ludwin Moran Sosa ’24 worked on creating the Field and Lab reports.

## Data

Initial iterations of these reports were created using data from 2018. Access the project on [github](https://github.com/LaurieLBaker/CEDS2024-Penobscot-Water) and find out more about the data in the [codebook](https://github.com/LaurieLBaker/CEDS2024-Penobscot-Water/tree/main/data).

## Resources

[Penobscot Nation Water Monitoring Project](https://www.penobscotnation.org/departments/department-of-natural-resources/water-n%c9%99pi-resources/)
[Jadey Ryan's Website](https://jadeyryan.com/)
Video: [Report writing in Quarto](https://youtu.be/Sf__ERCSgIA?si=9MUir2rQ41zEwha9)
Article: [Generating dynamic contents in R Markdown and Quarto ]

## Acknowledgements

Special thanks to Angie Reed, Jan Paul, and Maddie from the Penobscot Nation Water Resources team for guiding us through this process and taking the CEDS class out on the river to learn about the water quality sampling process. 

Thank you to Jadey Ryan whose workshop on parameterized reporting in Quarto provided us with the background knowledge to complete this project.

Thank you to Delphine Demaisy ’26 for explaining all the documents to us, compiling the codebook, and creating a draft field report template.

Thank you to Laurie Baker for advising us on this project and helping us work through code challenges.

Finally, thank you to the many resources on the internet that helped inspire our code.
