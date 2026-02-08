# RECAP Template: R - Large

## Purpose

This repository is a **[RECAP](https://recap-org.github.io)** template for **large academic data projects using R**, such as theses, working papers, collaborative research projects, or long-term replication efforts.

It provides a ready-to-use project structure and a reproducible execution environment that can be run:
- directly in the browser (e.g., GitHub Codespaces),
- or locally in common IDEs such as VS Code, Positron, or RStudio.

For guidance on how to run this template, choose an environment, or collaborate with others, see the main [RECAP documentation](https://recap-org.github.io).

## Getting started

To get started, click the **Use this template** button above the file list ⬆️.

You have two options: 

### Try it out online

1. Select **Open in a codespace**. 
2. Wait for the codespace to be created and started. **This may take up to 5 minutes.** ☕
3. Once the codespace is ready, you can follow the instructions in the **Basic demo** section below.

### Make your own copy

If you want to keep working on this project (locally or in the cloud), create your own copy of the template.

The RECAP documentation explains:
- how to create your own repository,
- how to run the template locally or in an isolated environment,
- and how to choose the setup that fits your needs.

➡️ See **[How to run a RECAP template](https://recap-org.github.io/docs/running-templates/)** on the RECAP website.

## Demo

First, install the R packages used in this template. Open a terminal and type:

```bash
Rscript -e "install.packages(c('tidyverse', 'modelsummary', 'testthat'))"
```

Then, open a terminal and type: 

```bash
make
```

This will execute the data cleaning step by running all the files `./src/data`, then the analysis by running all the files in `./src/analysis`, the compile the tex files in `./tex`. You will find the final documents (an article, its appendix, and a presentation) in the `./out/tex` directory and intermediary reports of the data cleaning and analysis steps in the `./out/src` directory.

## Using this template

This template is organized as follows

```bash
├── LICENSE # license file
├── README.md # this file
├── assets
│   ├── figures # where generated figures go (not committed to git)
│   ├── tables # where generated tables go (not committed to git)
│   ├── static # where external images and other static assets live (committed to git)
│   └── references.bib # latex bibliography file (committed to git)
├── data
│   ├── raw # raw data goes here (committed to git)
│   └── processed # processed data goes here (not committed to git)
├── src # all the code goes here
│   ├── data # scripts that process raw data into clean data
│   ├── main # scripts that generate do the analysis
│   └── lib # helper functions
├── _quarto.yaml # configuration for Quarto
├── .lintr # configuration for R linting
└── .devcontainer # configuration for the containerized environment
```

### Producing the report

#### Step 1: cleaning raw data

The raw data should be placed in the `./data/raw` directory, and committed to git (unless it is very large, in which case you should consider alternative storage solutions). 

The code that processes the raw data into clean data should be a series of Quarto `.qmd` scripts placed in the `./src/data` directory. These scripts should produce a series of clean datasets, to be placed in the `./data/processed` directory. To leverage our automated build pipeline, each script should be able to run in parallel (i.e., they should not depend on previous scripts). 

Using Quarto has a series of advantages. First, it always produces a single, traceable `.pdf` output that can be used for build pipelines. Second, Quarto provides easy to read command line output. Third, Quarto has a cache feature that can dramatically speed up code re-execution. 

#### Step 2: doing the analysis

The code that does the analysis uses the processed data to procude tables and figures used in the LaTeX documents. This code should be a series of Quarto `.qmd` scripts placed in the `./src/analysis` directory. These scripts take the processed data in `./data/processed` as inputs, and stores its outputs in `./assets/tables` and `./assets/figures`. This template provides the helper functions `save_figure` and `save_table` that do this for you. These functions are in `./src/lib/io.R`. To leverage our automated build pipeline, each script should be able to run in parallel (i.e., they should not depend on previous scripts). 

#### Step 3: compiling the LaTeX documents

Each LaTeX document is a sub-directory of `./tex`. The main `.tex` file of each document must be called `main.tex`. Each LaTeX document has symlinks to the `./assets` directory for shared use of the project's assets and bibliography. 

### Doing the whole analysis from scratch

In the terminal, you can run 
```bash
make
```
to run the analysis all at once. This will execute our three steps: process the data (scripts in `./src/data`) -> run the analysis (scripts in `./src/analysis`) -> compile the tex files (directories in `./tex`).

Run to get more details on the available commands:
```bash
make help 
```

You can customize `./Makefile` to change how the build steps are executed.

### External assets

A project may also use assets that are not generated by code (e.g., external images, bibliography, ...). These should be placed in `./assets/static` and committed to git. 

### Helper functions

Helper functions are shared across your data and analysis code. They are declared in `.R` files that are placed in `./src/lib`. Think of these helper functions as a quasi-R package that accompanies the project. As such, each of these functions should be properly documented so that all collaborators understand how they work.  


### Configuration

Look into the following files to tweak things as you see fit: 

- `./.lintr`: R linting options
- `./_quarto.yaml`: Quarto options; we provide a set of sane defaults
- `./Makefile`: customize how build steps are executed

## Software environment

This template comes with a reproducible execution environment that includes R, Quarto,LaTeX, and other useful tools. We rely on the [Dev Container](https://code.visualstudio.com/docs/devcontainers/containers) specification, which means that you can extend the environment by editting `./.devcontainer/devcontainer.json`.

The exact software stack (including versions) is documented in the **[RECAP 2026-q1 image release](https://github.com/recap-org/images/releases/tag/2026-q1)**.

This information is mainly useful if you need to check versions or debug environment-specific issues.  
You do not need to understand or modify this to use the template.

## Issues and feedback

If something doesn't work as expected, or if you have a suggestion for improving this template, please open an issue on this repository (Issue tab ⬆️).

You don't need to be sure that something is "really a bug" — unclear instructions, confusing behavior, or small setup problems are all worth reporting. Your feedback helps improve RECAP for everyone.

## Credits

We thank 

- [Jason Leung](https://unsplash.com/@ninjason?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) on [Unsplash](https://unsplash.com/photos/donkey-kong-arcade-game-screen-with-1981-date-c5tiCWrZADc?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) for that nice Donkey Kong photo.
- [grandmaster07](https://www.kaggle.com/grandmaster07) for the student exam score dataset analysis published on [Kaggle](https://www.kaggle.com/datasets/grandmaster07/student-exam-score-dataset-analysis)
