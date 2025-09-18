# Climbing Book LaTeX Template  

This repository provides a **LaTeX template** for creating a climbing guidebook. It is designed to give you a clean and structured starting point for documenting crag and route documentation in book form.  

The project uses the standard `book` class in LaTeX, with separate files for chapters, introduction, front matter, and back matter.  

---

## 📂 Project Structure  

```
src
  ├── main.tex          % The main LaTeX file – compile this one
  ├── frontmatter.tex   % Content before the main chapters (e.g., title page, TOC)
  ├── backmatter.tex    % Content after the main chapters (e.g., bibliography, index)
  └── figures/          % (Optional) Directory for images
Introduction.tex      % Your introduction section
chapters.tex          % Define and include your chapters here
config.tex            % Set values for the dynamic content in the template.
```

---

## ✍️ How to Use  

1. **Clone this repository**  
   ```bash
   git clone https://github.com/DreadClimber/climbing-book-template.git
   cd climbing-book-template
   ```

2. **Edit the content files**  
   - `chapters.tex` → Add or organize your main book chapters.  
   - `Introduction.tex` → Write the book’s introduction.  
   - `config.inc` → Specify the configurable options.

3. **Compile the book**  
   Run LaTeX (e.g., `pdflatex` or `xelatex`) on `main.tex`:  
   ```bash
   pdflatex main.tex
   ```
   Repeat as necessary for references, TOC, or indexing.  

4. **Add images**  
   Place any figures in the `figures/` directory and reference them in your chapters using standard LaTeX commands:  
   ```latex
   \includegraphics[width=\linewidth]{figures/example.png}
   ```

---

## 📖 Example Workflow  

- Write climbing route descriptions in `chapters.tex`.  
- Use `Introduction.tex` for a preface or background story.  
- Modify `config.tex`.  

---

## 🧗 Tips  

- Use neated `\climbingarea{}` for new chapters and sections.

---

## ⚖️ License  

This template is released under the [MIT License](LICENSE). Feel free to use and modify it for your own climbing book projects.
