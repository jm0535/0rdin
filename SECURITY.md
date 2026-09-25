# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          | Notes |
| ------- | ------------------ | ----- |
| 4.0.x   | :white_check_mark: | Current release (Tauri + React + webR) |
| 3.0.x   | :warning:          | Legacy Shiny/Electron app — critical fixes only |
| < 3.0   | :x:                | Unsupported |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to: **jimmy.moses@pnguot.ac.pg**

Please include the following information:

- Type of issue (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

## Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity
  - Critical: Within 7 days
  - High: Within 14 days
  - Medium: Within 30 days
  - Low: Next regular release

## Disclosure Policy

- Security advisories will be published after a fix is available
- We follow responsible disclosure practices
- Credit will be given to reporters (unless anonymity is requested)

## Security Measures in Ördin

### Current Security Features

1. **Local Execution**: All data processing happens locally, no data leaves your machine
2. **No External Dependencies**: R packages are bundled, reducing supply chain risks
3. **File System Isolation**: File access limited to user-selected files
4. **No Telemetry**: No data collection or analytics
5. **No Network Calls**: App runs completely offline after installation

### Known Limitations

- R code execution is not sandboxed
- User-provided CSV files are processed without extensive validation
- No code signing for installers (planned for future releases)

## Best Practices for Users

1. **Download from Official Sources**: Only download Ördin from:
   - GitHub Releases: https://github.com/jm0535/0rdin/releases
   - Official repository: https://github.com/jm0535/0rdin

2. **Verify Checksums**: Check file hashes before installation (provided in releases)

3. **Keep Updated**: Always use the latest version for security patches

4. **Data Privacy**: While Ördin doesn't transmit data, be cautious with sensitive datasets

5. **CSV Files**: Only open CSV files from trusted sources

## Security Updates

Security updates will be announced via:
- GitHub Security Advisories
- Release notes
- README updates

## Dependencies

We regularly update dependencies to address known vulnerabilities:
- Electron: Updated quarterly or when critical CVEs are discovered
- R packages: Updated semi-annually
- npm packages: Audited with `npm audit` before each release

## Contact

For any security concerns: **jimmy.moses@pnguot.ac.pg**

For general issues: https://github.com/jm0535/0rdin/issues

---

Thank you for helping keep Ördin and our users safe!
