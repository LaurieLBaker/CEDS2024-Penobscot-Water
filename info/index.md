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
This project is a collaboration between the Community Engaged Data Science class at College of the Atlantic and the Penobscot Nation's Water Resources Department's Water Quality Monitoring Program. For this project, we used R to create a new reporting structure that was easier to navigate. Our team did two reports, a field report (containing information about field samples) and a lab report (containing information about lab analysis). For this project, we were able to build on previous work done by Delphine Demaisy, another COA student. Her work, combined with a workshop by Jadey Ryan on parameterized reporting, provided us with the skills and knowledge to create these reports. Prior work on this project included an extensive codebook put together by Delphine Demaisy, as well as many documents explaining data and templates for us to base our code off of. Additionally, we had access to the report templates that have been used up until this point, providing us with a comparison point. 

“The Water Resources Program staff protect the health of Penobscot citizens and how they use their waters.” The purpose of this monitoring is to collect and assess water quality data to make sure standards are being met, rivers and tributaries are properly classified, provide accurate data to the Environmental Protection Agency, and catch potential water quality problems. The water quality standards used by the Penobscot Nation are approved by the Chief and Council, though jurisdictional issues from the Maine Indian Claims Settlement Act of 1980 prevents approval from the Environmental Protection Agency (EPA). Instead, the Penobscot Nation uses the Maine Department of Environmental Protection's water quality standards as a comparison point. The Penobscot Nation Water Resources Program collects data for extensive water quality monitoring at 66 river sites, 47 tributary sites (tributaries are defined as a small stream that flows into a larger river or lake), and 21 sites on 11 lakes. The data collected is used for general outreach, fish consumption advisories, dam removal analysis, modeling stream temperature, creating water quality reports, and writing rules and legislation.

The goals of this project were to create parameterized field  and lab reports that would generate a separate document for each collector, grouped data by date, and included quality control flags. The field report is coded so that a unique document can be generated for each collector (the person collecting the field samples) and so there is a unique section for each date, run, and site. There are also quality control flags at the top indicating which runs had samples that violated the quality control standards. The lab report is coded similarly, but instead it is broken down by constituent (what is being measured in the water) and then date within that. It shows the results of the lab analysis, and is coded to show when the quality control flags have been violated. 


## Project Outputs


Our project focused on revamping the field and lab reports used by PNWRP. The original field report, created in Microsoft Access, contained various data about the site visit, sample details, and collection tools. Our community partners requested a more navigable report with quality control flags and the ability to auto-generate reports by changing the collector’s initials.

We enhanced the field report by introducing tabs for easy navigation across different report sections. Each tab contains 3 to 4 tables with relevant data. Tables like ‘Water Temperature and DO’ include a filter section for easy data sorting. Users can also adjust the number of rows and column order. We incorporated control flags in the sample information section, using green to indicate samples collected correctly and red for those that didn’t follow the protocol. This streamlined report design ensures clarity and ease of use for the reader. Furthermore, the table of contents displays the collection dates for all samples. Upon selecting a date, additional header sections unfold, revealing the associated run code and site code. This interactive feature enhances the report’s usability, allowing users to access specific information swiftly.


<figure style="display: flex; justify-content: center;">
    <video src="Recording 2024-05-28 201148.mp4" width="320" height="240" controls preload>
    </video>
    <figcaption> Field Report.</figcaption>
</figure>



In the latter half of the term, we focused on developing a lab report with quality control flags similar to the field report. However, these flags were designed to highlight samples exceeding their recommended holding time before analysis. With approximately 10 constituents, each with a unique optimal holding time, this feature ensures the most accurate results.

Like the field report, this lab report also includes filtering and sorting capabilities. In our final iteration, we tailored the report to our community partners’ needs by organizing each sampling visit by the constituent. Instead of displaying results for all constituents together, they are presented under separate headers in the table of contents, facilitating a smoother transition between different lab reports.



<figure style="display: flex; justify-content: center;">
    <video src="Recording 2024-05-27 133028.mp4" width="320" height="240" controls preload>
    </video>
    <figcaption> Lab Report.</figcaption>
</figure>






## Team

During the Spring of 2024, Cedar Callahan (Class of 2025), Linnea Goh (Class of 2025), and Ludwin Moran Sosa (Class of 2024) worked on creating the Field and Lab reports.

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
