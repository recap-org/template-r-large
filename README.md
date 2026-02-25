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

### Try it out online (without saving your work)

1. Select **Open in a codespace**. 
2. Wait for the codespace to be created and started. **This may take up to 5 minutes.** ☕
3. Once the codespace is ready, you can follow the instructions in the **Basic demo** section below.

### Make your own copy (to save your work)

If you want to keep working on this project (locally or in the cloud), create your own copy of the template.

The RECAP documentation explains:
- how to create your own repository,
- how to run the template in the cloud, locally or in an isolated environment ,
- and how to choose the setup that fits your needs.

➡️ See **[How to run a RECAP template](https://recap-org.github.io/docs/running-templates/)** on the RECAP website.

## Demo

We use [renv](https://rstudio.github.io/renv/) to record the R packages used in the project. If you are running this template locally, make sure the `renv` package is installed and use it to restore the packages associated with the template. Open a terminal and type: 

```bash
Rscript -e "renv::restore()"
```

If you are running this template on GitHub Codespaces or in an isolated environment (Docker), you can skip this step; it was executed automatically as the environment was being put together. 

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
├── out # where generated outputs are stored (not committed to git)
├── _quarto.yaml # configuration for Quarto
├── .lintr # configuration for R linting
├── renv.lock # renv lockfile; records packages used in the project
├── renv # renv data
├── .Rprofile # launches renv when opening an R session
├── _vscode.R # R packages required for a pleasant experience with VS Code
└── .devcontainer # configuration for the containerized environment
```

### Producing the paper, appendix and presentation

This template uses `make` to orchestrate a multi-stage analysis pipeline.  
Before modifying the build system, we strongly recommend reading: [Building your project with make](https://recap-org.github.io/docs/building-with-make)

#### Running the full analysis

To run the entire pipeline from scratch, use:

```bash
make
```

This command will:
1. process the data (`./src/data`),
2. run the analysis (`./src/analysis`),
3. compile the LaTeX documents (`./tex`).

Every RECAP large template also provides a `make help` command that lists the supported build targets and utility commands.  
If you are unsure how the project is meant to be used, this is always the right starting point.

You can customize the `./Makefile` to adapt the pipeline to your needs.  
For a conceptual overview of how RECAP uses `make` at this scale, refer back to the documentation page linked above.

The rest of this section explains how the large template is organized and how your code should fit into that structure.

#### Step 1: cleaning raw data

Raw data should be placed in the `./data/raw` directory and committed to git (unless it is very large, in which case you should consider alternative storage solutions).

Data-cleaning code should consist of a series of Quarto `.qmd` scripts placed in the `./src/data` directory.  
These scripts produce clean, analysis-ready datasets, stored in `./data/processed`.

To leverage the automated build pipeline, each script should be able to run independently (that is, scripts should not depend on one another).

Using Quarto at this stage ensures that each step produces a single, traceable output that integrates cleanly with the build system.

#### Step 2: doing the analysis

Analysis code should be placed in the `./src/analysis` directory as a series of Quarto `.qmd` scripts.

These scripts:
- take processed data from `./data/processed` as input,
- produce tables and figures stored in `./assets/tables` and `./assets/figures`.

The template provides helper functions for this purpose (for example, to save figures and tables in a consistent way). These functions live in `./src/lib/io.R`.

As in the data step, analysis scripts should be written so they can run in parallel.

#### Step 3: compiling the LaTeX documents

Each LaTeX document lives in its own subdirectory of `./tex`.  The main file of each document must be called `main.tex`.

### External assets

A project may also use assets that are not generated by code (e.g., external images, bibliography, ...). These should be placed in `./assets/static` and committed to git. 

### Helper functions

Helper functions are shared across your data and analysis code. They are declared in `.R` files that are placed in `./src/lib`. Think of these helper functions as a quasi-R package that accompanies the project. As such, each of these functions should be properly documented so that all collaborators understand how they work.  

### Tests

This template includes a basic testing setup using the `testthat` package.

If you are not familiar with how testing works in RECAP, we recommend first reading our [documentation on tests](https://recap-org.github.io/docs/tests).

All test files must:

- live in the `tests/` directory, and
- have filenames that start with `test-`.

To run all tests, use:

```bash
make tests
```

For details on writing tests, see the official `testthat` [documentation](https://testthat.r-lib.org/).

### Dependency management

This template uses explicit dependency management for R packages.

If you are not familiar with dependency management in RECAP, we recommend first reading our [documentation on dependency management](https://recap-org.github.io/docs/dependency-management)

We use the `renv` package to record the exact R package versions required by the project. This is enabled by default, as it is good practice for long-running, complex research projects. For detailed documentation on `renv`, see its [documentation](https://rstudio.github.io/renv/). 

For implementation details about how `renv` is configured inside the development container
(e.g. use of `pak`, cache handling), see the comments in `.devcontainer/devcontainer.json`.

If you prefer not to use explicit dependency management, you can remove it as follows:

- Delete `./renv.lock`, `./renv`, and `./.Rprofile`.
- In `.devcontainer/devcontainer.json`, comment out the line:

  `"postCreateCommand": "Rscript -e 'renv::restore()'"`

  This disables automatic restoration of R package versions when the container is created.

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
