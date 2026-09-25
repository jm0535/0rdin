# Contributing to Ördin

Thank you for your interest in contributing to Ördin! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### 🐛 Reporting Bugs

**Before submitting a bug report:**
- Check the [documentation index](../docs/DOCS-INDEX.md) and the
  [Quick Start troubleshooting table](../docs/QUICKSTART.md#5-troubleshooting)
- Search existing issues to avoid duplicates

**When submitting a bug report, include:**
- Ördin version (from `package.json`, currently 4.0.0)
- How you run it: web app, desktop build, or `npm run dev`
- Browser/OS version (and whether `crossOriginIsolated` is true in the console)
- Node.js version (run `node --version`) if building from source
- Steps to reproduce the issue
- Expected vs actual behavior
- Screenshots (if applicable)
- Error messages from DevTools console

### 💡 Suggesting Enhancements

**Before suggesting an enhancement:**
- Check the [changelog](../CHANGELOG.md) to see if it's already planned
- Search existing feature requests

**When suggesting an enhancement, include:**
- Clear description of the feature
- Use case: What problem does it solve?
- Example implementation (if you have ideas)
- Mockups or screenshots (for UI changes)

### 📝 Contributing Code

#### First-Time Contributors

Good first issues:
- Documentation improvements
- UI/theme tweaks in `packages/ui` or the panel components
- New sample datasets
- Additional plot customisation controls
- Bug fixes with clear reproduction steps

#### Development Process

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/ordin.git
   cd ordin
   ```

2. **Set up the development environment** (Node.js ≥ 22)
   ```bash
   npm install
   npm run dev          # http://localhost:9054
   ```
   See [`docs/DEVELOPMENT.md`](../docs/DEVELOPMENT.md) for the full workflow.

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**
   - Follow the code style guide (see below)
   - Test your changes thoroughly
   - Add documentation if needed

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: Add your feature description"
   ```
   
   Use [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `style:` Code style changes (formatting, etc.)
   - `refactor:` Code refactoring
   - `test:` Adding tests
   - `chore:` Maintenance tasks

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**
   - Describe what your PR does
   - Link to related issues
   - Include screenshots for UI changes
   - Ensure all checks pass

## Code Style Guide

### TypeScript / React (the v4 app)

```ts
// Good
export async function runBeta(matrix: number[][]): Promise<BetaResult> {
  const result = await runBetaViaWebR(matrix);
  return result;
}

// Bad
export async function RunBeta(matrix:any){return await runBetaViaWebR(matrix)}
```

**Key points:**
- TypeScript everywhere, `strict` mode; avoid `any` in exported signatures.
- 2-space indentation, semicolons, `const` over `let`, no `var`.
- camelCase for values, PascalCase for components and types.
- Components stay presentational: state goes through the `@ordin/core` store,
  statistics through `@ordin/processing` — never import `webr` in a component.
- Every analysis result must carry a `provenance` string, and the UI must show it.
- Tailwind utility classes for styling; follow the existing palette
  (`#121214` background, `#2d2d30` borders, `#2e8b57` accent).
- Run `npm run lint` and `npm run typecheck` before pushing.

### R inside webR snippets

Follow the [tidyverse style guide](https://style.tidyverse.org/):

```r
# Good
fit <- vegan::adonis2(dist ~ group, data = env, permutations = 999)

# Bad
fit<-adonis2(dist~group,data=env,permutations=999)
```

- Fully qualify package functions (`vegan::`, `iNEXT::`) inside webR calls.
- Only use packages from the allow-list in
  [`docs/ORDIN_STACK_AUDIT_2026-09-26.md`](../docs/ORDIN_STACK_AUDIT_2026-09-26.md).
- Always purge webR shelters in a `finally` block.

### Legacy R Shiny code (`shiny/`)

Maintenance-only. Keep the existing tidyverse style, 2-space indentation and
`<-` assignment; see [`CODE_STANDARDS.md`](CODE_STANDARDS.md).

## Testing Guidelines

### Manual Testing Checklist

Before submitting a PR, test:

**Automated:**
```bash
npm run lint
npm run typecheck
npm run test:frontend
```

**Basic Functionality:**
- [ ] `npm run dev` starts without console errors
- [ ] Sample data (`dune`) loads correctly
- [ ] iNEXT analysis runs and shows `REAL … via webR` provenance
- [ ] NMDS analysis runs and displays results
- [ ] PERMANOVA runs and reports a p-value
- [ ] CSV/JSON download works
- [ ] SVG/PNG plot export works
- [ ] `.ordin` project saves and reloads

**Error Handling:**
- [ ] Invalid CSV shows error message
- [ ] Missing columns handled gracefully
- [ ] Non-numeric data shows error
- [ ] Empty file handled properly

**UI/UX:**
- [ ] All buttons are clickable
- [ ] Theme renders correctly
- [ ] Tables are readable
- [ ] Plots display properly
- [ ] Responsive layout works

**Cross-Platform (if applicable):**
- [ ] Works on Windows
- [ ] Works on macOS
- [ ] Build process succeeds

### Automated Tests

- Unit tests: `node:test` + `tsx` in `tests/` (`npm run test:frontend`)
- End-to-end and accessibility: Playwright + `@axe-core/playwright`
- Legacy R suite: `testthat` under `shiny/tests/`

CI runs lint, typecheck and the unit tests on every pull request.

## Adding New Features

### Adding a new analysis

1. **Model the result** — add a slot under `OrdinProject['analyses']` in
   `packages/core/src/index.ts` (include `ranAt` and `provenance`).
2. **Implement the computation** in `packages/processing/src/index.ts`:
   a webR call (`run<Name>ViaWebR`) and/or a JavaScript fast path.
   ```ts
   export async function runMyAnalysisViaWebR(matrix: number[][]) {
     const w = await getWebR();
     await w.evalRVoid('library(vegan)');
     // … build R code, evaluate, convert with toJs()
     return { /* typed result */, provenance: 'REAL vegan::myfun via webR' };
   }
   ```
3. **Wire the UI** — add controls to the relevant panel in
   `apps/ordin-desktop/src/components/panels/` and surface the provenance badge.
4. **Document it** — update `docs/FEATURES-OVERVIEW.md`, add a guide under
   `docs/guides/` if user-facing, and add a `CHANGELOG.md` entry.

### Adding a new panel

See the step-by-step list in
[`docs/DEVELOPMENT.md`](../docs/DEVELOPMENT.md#adding-a-panel).

### Adding an R package

New packages increase the WASM download for every user. Justify the addition
against the allow-list in
[`docs/ORDIN_STACK_AUDIT_2026-09-26.md`](../docs/ORDIN_STACK_AUDIT_2026-09-26.md)
and update that document in the same PR.

### Theming

Colours and typography live in Tailwind config and `apps/ordin-desktop/src/index.css`.
Keep dark and light themes in sync and check contrast.

## Documentation

### Documentation Standards

- **Code comments**: Explain WHY, not WHAT
- **Function docs**: Include parameters, return values, examples
- **README updates**: Keep in sync with code changes
- **Changelog**: Document all user-facing changes

### Example function documentation

```ts
/**
 * Run iNEXT diversity estimation in webR.
 *
 * @param matrix Sites × species abundance matrix.
 * @param opts   Hill orders, data type, knots, endpoint, bootstrap settings.
 * @returns `DataInfo`, `AsyEst` and `iNextEst` tables plus a provenance string.
 */
export async function runInextViaWebR(
  matrix: number[][],
  opts: { q: number[]; datatype: 'abundance' | 'incidence'; knots: number;
          endpoint?: number | null; nboot: number; conf: number },
) { /* … */ }
```

## Commit Message Guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Updating build tasks, package manager configs, etc.

**Examples:**

```
feat: Add PCA ordination method

Implements PCA ordination using vegan::rda(). Includes:
- UI selector for PCA
- Analysis logic with eigenvalue display
- Biplot visualization

Closes #123
```

```
fix: Handle empty CSV files gracefully

Previously, uploading an empty CSV would crash the app.
Now displays a user-friendly error message.

Fixes #456
```

## Review Process

### What Reviewers Look For

- **Functionality**: Does it work as intended?
- **Code quality**: Is it readable and maintainable?
- **Performance**: Are there any bottlenecks?
- **Documentation**: Is it well-documented?
- **Testing**: Has it been tested thoroughly?
- **Style**: Does it follow the style guide?

### Responding to Feedback

- Be open to suggestions
- Ask for clarification if needed
- Make requested changes promptly
- Push updates to the same branch

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md (coming soon)
- Mentioned in release notes for significant contributions
- Credited in the About section of the app

## Questions?

- Open an issue for general questions
- Email jimmy.moses@pnguot.ac.pg for private inquiries
- Check [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) for architecture details

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Ördin!** 🌿

Your efforts help make biodiversity analysis more accessible to researchers worldwide.
