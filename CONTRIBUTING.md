# Contributing to PIQC Knowledge Base

Thank you for your interest in contributing! 🎉

The PIQC Knowledge Base is a community-driven resource that improves through the collective experience of ML practitioners, platform engineers, SREs, and AI operators worldwide.

Your contributions help establish better deployment standards for the entire AI infrastructure ecosystem.

---

## 🌟 Ways to Contribute

### 💬 1. Share Your Experience 

Have you deployed an LLM in production? Discovered a critical checklist item we missed? Encountered a common failure mode?

**Start a discussion:**
- Go to [GitHub Discussions](https://github.com/paralleliq/piqc-knowledge-base/discussions)
- Share your story, question, or insight
- Engage with the community

**Best discussion topics:**
- Real-world deployment challenges and solutions
- Infrastructure architecture decisions and tradeoffs
- Cost optimization techniques
- Observability and debugging strategies
- Compliance and governance experiences

---

### 📝 2. Improve Existing Content 

Found a typo? Unclear wording? Missing context?

**Quick fixes:**
1. Click the "Edit" button on any file in GitHub
2. Make your change
3. Submit a pull request with a clear description

**For larger improvements:**
1. Open an issue first to discuss the change
2. Get feedback from maintainers
3. Submit a PR referencing the issue

---

### ✅  3. Add New Checklist Items 

Think we're missing an important validation step?

**Before submitting:**
- Check that it's not already covered elsewhere
- Ensure it's **framework-agnostic** (not specific to one tool)
- Make it **actionable** (can be clearly validated)
- Verify it applies **broadly** (not just your niche use case)

**Submission process:**
1. Open an issue titled "New Checklist Item: [Brief Description]"
2. Explain: **What** to check, **Why** it matters, **How** to validate
3. Provide examples if possible
4. Wait for maintainer feedback
5. Submit PR if approved

---

### 🎯 4. Contribute Real-World Examples 

Examples make checklists actionable. We especially value:

- **YAML/JSON configuration snippets**
- **Before/After comparisons** (with metrics)
- **Architecture diagrams**
- **Troubleshooting case studies**
- **Cost analysis examples**

**What makes a good example:**
- Realistic and representative of common scenarios
- Includes context (model size, traffic, infrastructure)
- Anonymized if from production systems
- Shows quantitative impact when possible

---

### 🏢  5. Expand Domain-Specific Guidance 

Have expertise in a specific industry or use case?

**We need contributions for:**
- Healthcare (HIPAA, clinical validation)
- Finance (model risk management, fair lending)
- Retail/E-commerce (personalization compliance)
- Public sector (algorithmic impact assessments)
- Gaming (real-time inference optimization)
- Autonomous systems (safety-critical AI)

---

## 📋 Contribution Guidelines

### Content Principles

All PIQC content must be:

#### ✅ Framework-Agnostic
- **Good:** "Verify tensor parallel configuration matches GPU count"
- **Bad:** "Set `vllm --tensor-parallel-size=4`"

Reasoning: PIQC applies to vLLM, TGI, Triton, Ray Serve, and custom runtimes

#### ✅ Vendor-Neutral
- **Good:** "Ensure model storage bandwidth supports loading time SLOs"
- **Bad:** "Use AWS S3 with provisioned IOPS"

Reasoning: Teams use AWS, GCP, Azure, on-prem, and hybrid environments

#### ✅ Actionable
- **Good:** "Measure cold start time under realistic conditions"
- **Bad:** "Be aware of cold start implications"

Reasoning: Checklists should be unambiguous and verifiable

#### ✅ Broadly Applicable
- **Good:** "Document maximum input size constraints"
- **Bad:** "Configure CUDA graph capture for batch size 8 on A100s"

Reasoning: PIQC serves diverse teams with different hardware and requirements

---

### Checklist Item Template

When proposing new checklist items, use this format:

```markdown
- [ ] **[Specific action or validation]**

<details>
<summary>💡 Why this matters</summary>

[Explain the risk or inefficiency this addresses. Include failure modes or common misconfigurations.]

</details>

<details>
<summary>📝 How to validate</summary>

[Provide clear steps to verify this item. Include tools, commands, or metrics where appropriate.]

</details>

<details>
<summary>🎯 Example</summary>

[Show a concrete example, preferably with before/after comparison or sample configuration.]

</details>
```

**Example:**

```markdown
- [ ] **GPU memory headroom validated under peak batch size**

<details>
<summary>💡 Why this matters</summary>

Running at 95%+ GPU memory utilization causes OOM failures during traffic spikes or variable input sizes. A 10-15% memory buffer prevents crashes while maximizing throughput.

</details>

<details>
<summary>📝 How to validate</summary>

1. Load model with max batch size
2. Run synthetic traffic with p99 input length
3. Monitor `nvidia-smi` or DCGM for peak memory usage
4. Verify peak usage < 85% of total GPU memory

</details>

<details>
<summary>🎯 Example</summary>

**System:** Llama-2-7B on A10G (24GB)
- Batch size: 16
- Sequence length: 2048
- Peak memory: 19.2GB (80%)
- Result: ✅ Safe headroom

</details>
```

---

### Pull Request Process

1. **Fork the repository** and create a feature branch
   ```bash
   git checkout -b add-observability-checklist-item
   ```

2. **Make your changes** following the guidelines above

3. **Test formatting** by previewing Markdown locally

4. **Commit with clear messages**
   ```bash
   git commit -m "Add GPU memory headroom validation to deployment checklist"
   ```

5. **Push and create PR**
   ```bash
   git push origin add-observability-checklist-item
   ```

6. **Fill out the PR template** completely
   - Describe your changes
   - Link to related issues
   - Explain why this improves PIQC

7. **Respond to feedback** from maintainers

8. **Celebrate** when your PR is merged! 🎉

---

### PR Checklist

Before submitting, verify:

- [ ] Content is framework-agnostic and vendor-neutral
- [ ] New checklist items follow the template
- [ ] Examples are realistic and well-documented
- [ ] No proprietary or confidential information included
- [ ] Markdown formatting is correct (preview in GitHub)
- [ ] Spelling and grammar are correct
- [ ] Links are functional
- [ ] Changes don't break existing content

---

## 🎨 Style Guide

### Writing Style

- Use **clear, concise language**
- Prefer **active voice** over passive
- Use **American English** spelling
- Write for an **intermediate-to-advanced** technical audience
- Be **opinionated but humble** (acknowledge tradeoffs)

### Formatting

- Use `##` for main sections, `###` for subsections
- Use `-` for unordered lists
- Use GitHub checkbox syntax: `- [ ]` for incomplete, `- [x]` for complete
- Use **bold** for emphasis, `code blocks` for technical terms
- Use emoji sparingly and consistently (see emoji guide below)

### Emoji Guide

| Context | Emoji | Usage |
|---------|-------|-------|
| Goals/objectives | 🎯 | Section goals, key points |
| Tips/insights | 💡 | Why something matters, pro tips |
| Examples | 📝 | Code samples, configurations |
| Warnings | ⚠️ | Important caveats, gotchas |
| Success | ✅ | Completed items, good examples |
| Issues | ❌ | Anti-patterns, bad examples |
| Tools/metrics | 📊 | Observability, dashboards |
| Security | 🔒 | Compliance, access control |
| Performance | 🚀 | Optimization, speed |
| Community | 🤝 | Collaboration, contributions |

---

## 🚫 What We Don't Accept

To keep PIQC neutral and broadly applicable, we **cannot accept**:

### ❌ Vendor-Specific Recommendations
- Product promotions or endorsements
- Tool-specific configuration (unless demonstrating a concept)
- Competitive comparisons

### ❌ Proprietary Content
- Closed-source algorithms or scoring logic
- Confidential company information
- Customer data or case studies without permission

### ❌ Overly Niche Content
- Single-company workflows that don't generalize
- Experimental features not widely adopted
- Deprecated or obsolete practices

### ❌ Non-Technical Content
- Marketing materials
- Job postings or recruitment
- Unrelated discussions

---

## 🏆 Recognition

Contributors are recognized in several ways:

### 1. GitHub Contributors Badge
All PR contributors automatically appear in the repository's contributor graph

### 2. Attribution in Content
Significant contributions (new sections, major improvements) will be attributed:
```markdown
*Contributed by [@username](https://github.com/username)*
```

### 3. Community Spotlight
Exceptional contributions may be featured in:
- ParalleliQ blog posts
- Social media shoutouts
- Conference talks or presentations

---

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of:
- Experience level
- Company or organization
- Geographic location
- Background or identity

### Expected Behavior

- **Be respectful** in all interactions
- **Be constructive** with feedback
- **Be collaborative** and open to different perspectives
- **Be patient** with newcomers
- **Be professional** in disagreements

### Unacceptable Behavior

- Harassment, discrimination, or personal attacks
- Trolling, insulting comments, or inflammatory remarks
- Sharing others' private information without consent
- Spam, self-promotion, or off-topic content

### Enforcement

Violations may result in:
1. Warning
2. Temporary ban from contributing
3. Permanent ban from the project

Report violations to: [sam@paralleliq.ai](mailto:sam@paralleliq.ai)

---

## 📧 Questions?

**General questions:**
- Open a [GitHub Discussion](https://github.com/paralleliq/piqc-knowledge-base/discussions)

**Specific issues:**
- Create a [GitHub Issue](https://github.com/paralleliq/piqc-knowledge-base/issues)

**Private inquiries:**
- Email: [sam@paralleliq.ai](mailto:sam@paralleliq.ai)

---

## 🙏 Thank You

Every contribution, no matter how small, makes PIQC better for the entire AI community.

By contributing, you're helping teams worldwide deploy AI systems more safely, efficiently, and reliably.

**We appreciate you!** 🌟

---

<div align="center">
  <strong>Ready to contribute?</strong>
  <br/>
  <a href="https://github.com/paralleliq/piqc-knowledge-base/issues">🐛 Find an Issue</a> •
  <a href="https://github.com/paralleliq/piqc-knowledge-base/discussions">💬 Start a Discussion</a> •
  <a href="https://github.com/paralleliq/piqc-knowledge-base/fork">🔧 Fork the Repo</a>
</div>

---

<div align="center">
  <sub>Part of the <a href="https://github.com/paralleliq/piqc-knowledge-base">PIQC Knowledge Base</a></sub>
  <br/>
  <sub>Maintained by <a href="https://paralleliq.ai">ParalleliQ</a></sub>
</div>

### 6. Licensing
All contributions are made under the BSL License included in this repository.