export

# --- I/O colors ---
GREEN_START = \033[1;32m
GREEN_END = \033[0m

# ---- Define target paths ----
# R targets
R_LIBS = $(wildcard ./src/lib/*.R)
R_DATA = $(patsubst ./src/data/%.qmd, ./bin/src/data/%.pdf, $(wildcard ./src/data/*.qmd))
R_ANALYSIS = $(patsubst ./src/analysis/%.qmd, ./bin/src/analysis/%.pdf, $(wildcard ./src/analysis/*.qmd))

# LaTex targets
PDF_FILES = $(patsubst ./tex/%,./bin/tex/%.pdf,$(wildcard ./tex/*)) 


# ---- Main targets ----
all: $(PDF_FILES)
.SECONDARY: $(R_ANALYSIS) $(R_DATA) $(STATA_ANALYSIS) $(STATA_DATA)
.PHONY: all clean fresh clear-cache tests initialize

# ---- Step 1: Data ----
./bin/src/data/%.pdf: ./src/data/%.qmd $(R_LIBS)
	@echo "🗄️ $(GREEN_START)Data processing$(GREEN_END)"
	@$(call build_qmd,$<)

# ---- Step 2: Analysis ----
./bin/src/analysis/%.pdf: ./src/analysis/%.qmd $(R_DATA) $(R_LIBS)
	@echo "📊 $(GREEN_START)Running analysis$(GREEN_END)"
	@$(call build_qmd,$<)

# ---- Step 3: Paper ----
./bin/tex/%.pdf: ./tex/%/main.tex $(R_ANALYSIS)
	@$(call build_tex,$<)

clean: ## Clean up intermediate latex files
	@echo "🧹 $(GREEN_START)Cleaning up...$(GREEN_END)"
	@find ./tex -type f ! -name '*.tex' -delete
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"

fresh: ## Delete all targets
	@echo "😵 $(GREEN_START)Deleting all targets and intermediary files...$(GREEN_END)"
	@find ./bin -type f -name "*.pdf" -delete
	@find ./bin -type f -name "*.log" -delete
	@find ./bin -type f -name "*.log" -delete
	@find ./assets/tables -type f ! -name ".gitignore" -delete
	@find ./assets/figures -type f ! -name ".gitignore" -delete
	@find ./data/processed -type f ! -name ".gitignore" -delete
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"

clear-cache: ## Clear cache of .qmd files
	@echo ""📦 $(GREEN_START)Clearing cache...$(GREEN_END)""
	@find ./src -depth -type d -name "*_cache" -exec rm -rf {} \;
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"

tests: ## Run tests
	@echo "🧪 $(GREEN_START)Running tests...$(GREEN_END)"
	@Rscript -e "testthat::test_dir('tests')"

symlinks: ## Create symlinks to assets in each LaTeX subdirectory
	@echo "🛠️ $(GREEN_START)Creating symlinks to assets folder...$(GREEN_END)"
	@for dir in ./tex/*/; do \
		if [ -d "$$dir" ]; then \
			echo "Creating symlinks in $$dir..."; \
			ln -sf "../../assets" "$$dir/assets"; \
		fi; \
	done
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"

help: ## Display this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

# ---- functions ----

# build_tex
# -----------
# Compiles a LaTeX file in ./tex/DIR/main.tex and copies the resulting PDF to ./bin/tex/DIR.pdf
# Arguments:
#   $1 - Path to the LaTeX main.tex file (e.g., tex/article/main.tex)
define build_tex
	$(eval TARGET := $(patsubst tex/%/main.tex,bin/tex/%.pdf,$(1)))
	@echo "📝 $(GREEN_START)Compiling $(1) -> $(TARGET)...$(GREEN_END)"
	@mkdir -p ./bin/tex/
	@cd $(dir $(1)) &&\
		latexmk -pdf -quiet\
		-interaction=nonstopmode $(notdir $(1))
	@cp $(basename $(1)).pdf $(TARGET)
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"
endef

# ---- functions ----

# build_qmd
# -----------
# Renders a Quarto document (.qmd) and generates a PDF output in the bin directory
# Arguments:
#   $1 - Path to the .qmd file (e.g., src/analysis/main.qmd -> bin/src/analysis/main.pdf)
define build_qmd
	$(eval TARGET := $(patsubst %.qmd,bin/%.pdf,$(1)))
	@echo "📄 $(GREEN_START)Rendering $(1) -> $(TARGET)...$(GREEN_END)"
	@quarto render $(1)
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"
endef

# build_R
# -----------
# Run an R script
# Arguments:
#   $1 - Path to the .R file (e.g., src/lib/io.R)
define build_R
	@echo "📄 $(GREEN_START)Running $(1)...$(GREEN_END)"
	@Rscript $(1)
	@echo "✅ $(GREEN_START)Done!$(GREEN_END)"
endef