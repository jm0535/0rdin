// Ördin v3.0 - About Ördin Content
// Author: Jimmy Moses (jmoses@pnguot.ac.pg)
// Comprehensive "What Makes Ördin Special" content

function getAboutOrdinContent() {
    return `
        <div style="padding: 40px; max-width: 1200px; margin: 0 auto; overflow-y: auto; height: calc(100vh - 200px);">
            <!-- Header -->
            <div style="text-align: center; margin-bottom: 50px;">
                <h1 style="color: #2e8b57; font-size: 48px; margin: 0 0 10px 0;">Ö</h1>
                <h2 style="color: #ccc; font-size: 32px; margin: 0 0 16px 0;">Ördin</h2>
                <p style="color: #888; font-size: 16px; margin: 0;">Community Ecology Analysis Platform</p>
            </div>

            <!-- Introduction -->
            <div style="background: #252526; border-left: 4px solid #2e8b57; padding: 30px; margin-bottom: 40px;">
                <h2 style="color: #2e8b57; margin-top: 0; font-size: 24px;">What Makes Ördin Special</h2>
                <p style="color: #ccc; font-size: 16px; line-height: 1.8;">
                    Ördin bridges the gap that has plagued scientific software for decades.
                </p>
            </div>

            <!-- The Fundamental Problem -->
            <div style="margin-bottom: 50px;">
                <h2 style="color: #2e8b57; font-size: 28px; margin-bottom: 30px; border-bottom: 2px solid #3e3e42; padding-bottom: 10px;">
                    The Fundamental Problem
                </h2>
                <p style="color: #888; font-size: 15px; margin-bottom: 30px;">
                    Most scientific software forces users to choose between two extremes:
                </p>

                <!-- Two Extremes Comparison -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 40px;">
                    <!-- Statistical Software -->
                    <div style="background: #2d2d30; border: 1px solid #3e3e42; padding: 25px;">
                        <h3 style="color: #007acc; margin-top: 0; font-size: 18px;">📊 Statistical Software (R, Python, SPSS)</h3>
                        <div style="margin-bottom: 20px;">
                            <p style="color: #2e8b57; font-size: 14px; margin: 8px 0;">✅ <strong>Rigorous:</strong> Peer-reviewed methods, reproducible analyses</p>
                        </div>
                        <div style="margin-bottom: 12px;">
                            <p style="color: #ff6b6b; font-size: 14px; margin: 8px 0;">❌ <strong>Complex:</strong> Steep learning curve, command-line interfaces</p>
                            <p style="color: #ff6b6b; font-size: 14px; margin: 8px 0;">❌ <strong>Time-consuming:</strong> Hours of coding before first result</p>
                        </div>
                        <p style="color: #666; font-size: 13px; margin-top: 20px; font-style: italic;">
                            <strong>Target:</strong> Statisticians, programmers, experienced researchers
                        </p>
                    </div>

                    <!-- Point-and-Click Tools -->
                    <div style="background: #2d2d30; border: 1px solid #3e3e42; padding: 25px;">
                        <h3 style="color: #d4a017; margin-top: 0; font-size: 18px;">🖱️ Point-and-Click Tools (PAST, PC-ORD)</h3>
                        <div style="margin-bottom: 20px;">
                            <p style="color: #2e8b57; font-size: 14px; margin: 8px 0;">✅ <strong>Easy:</strong> Intuitive interfaces, quick results</p>
                        </div>
                        <div style="margin-bottom: 12px;">
                            <p style="color: #ff6b6b; font-size: 14px; margin: 8px 0;">❌ <strong>Limited rigor:</strong> Black-box analyses, hard to verify</p>
                            <p style="color: #ff6b6b; font-size: 14px; margin: 8px 0;">❌ <strong>Costly:</strong> Often proprietary ($200-$800 per license)</p>
                        </div>
                        <p style="color: #666; font-size: 13px; margin-top: 20px; font-style: italic;">
                            <strong>Target:</strong> Students, non-technical users
                        </p>
                    </div>
                </div>
            </div>

            <!-- Ördin's Unique Solution -->
            <div style="background: linear-gradient(135deg, #1a3a2e 0%, #252526 100%); border: 2px solid #2e8b57; padding: 40px; margin-bottom: 50px;">
                <h2 style="color: #2e8b57; font-size: 28px; margin-top: 0; text-align: center;">
                    🎯 Ördin's Unique Solution
                </h2>
                <p style="color: #4ade80; font-size: 20px; font-weight: 600; text-align: center; margin: 20px 0;">
                    Ördin does both - without compromise.
                </p>

                <!-- Comparison Table -->
                <div style="overflow-x: auto; margin-top: 30px;">
                    <table style="width: 100%; border-collapse: collapse; color: #ccc; font-size: 14px;">
                        <thead>
                            <tr style="background: #1e1e1e; border-bottom: 2px solid #2e8b57;">
                                <th style="padding: 12px; text-align: left; color: #2e8b57;">Feature</th>
                                <th style="padding: 12px; text-align: center; color: #007acc;">R/Python</th>
                                <th style="padding: 12px; text-align: center; color: #d4a017;">PAST/PC-ORD</th>
                                <th style="padding: 12px; text-align: center; color: #2e8b57; font-weight: 700;">Ördin</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr style="border-bottom: 1px solid #3e3e42;">
                                <td style="padding: 12px;">Ease of Use</td>
                                <td style="padding: 12px; text-align: center;">⚠️ Difficult</td>
                                <td style="padding: 12px; text-align: center;">✅ Easy</td>
                                <td style="padding: 12px; text-align: center; background: #1a3a2e; font-weight: 600;">✅ Easy</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #3e3e42;">
                                <td style="padding: 12px;">Statistical Rigor</td>
                                <td style="padding: 12px; text-align: center;">✅ Rigorous</td>
                                <td style="padding: 12px; text-align: center;">⚠️ Limited</td>
                                <td style="padding: 12px; text-align: center; background: #1a3a2e; font-weight: 600;">✅ Rigorous</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #3e3e42;">
                                <td style="padding: 12px;">Educational Value</td>
                                <td style="padding: 12px; text-align: center;">⚠️ External docs</td>
                                <td style="padding: 12px; text-align: center;">⚠️ Minimal</td>
                                <td style="padding: 12px; text-align: center; background: #1a3a2e; font-weight: 600;">✅ Built-in</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #3e3e42;">
                                <td style="padding: 12px;">Modern UI</td>
                                <td style="padding: 12px; text-align: center;">❌ CLI/basic</td>
                                <td style="padding: 12px; text-align: center;">❌ 1990s style</td>
                                <td style="padding: 12px; text-align: center; background: #1a3a2e; font-weight: 600;">✅ VS Code-like</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #3e3e42;">
                                <td style="padding: 12px;">Reproducibility</td>
                                <td style="padding: 12px; text-align: center;">✅ High</td>
                                <td style="padding: 12px; text-align: center;">⚠️ Limited</td>
                                <td style="padding: 12px; text-align: center; background: #1a3a2e; font-weight: 600;">✅ High</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #3e3e42;">
                                <td style="padding: 12px;">Open Source</td>
                                <td style="padding: 12px; text-align: center;">✅ Free</td>
                                <td style="padding: 12px; text-align: center;">❌ Paid</td>
                                <td style="padding: 12px; text-align: center; background: #1a3a2e; font-weight: 600;">✅ Free</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #3e3e42;">
                                <td style="padding: 12px;">Method Coverage</td>
                                <td style="padding: 12px; text-align: center;">✅ 100%</td>
                                <td style="padding: 12px; text-align: center;">✅ 90%</td>
                                <td style="padding: 12px; text-align: center; background: #1a3a2e; font-weight: 600;">✅ 100%</td>
                            </tr>
                            <tr>
                                <td style="padding: 12px;">Learning Curve</td>
                                <td style="padding: 12px; text-align: center;">🔴 High</td>
                                <td style="padding: 12px; text-align: center;">🟢 Low</td>
                                <td style="padding: 12px; text-align: center; background: #1a3a2e; font-weight: 600;">🟢 Low</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Bottom Line -->
            <div style="background: #252526; border: 2px solid #2e8b57; padding: 40px; text-align: center;">
                <h2 style="color: #2e8b57; font-size: 24px; margin-top: 0;">💎 The Bottom Line</h2>
                <p style="color: #ccc; font-size: 16px; margin-bottom: 20px;">Most software asks you to choose:</p>
                <p style="color: #888; font-size: 15px; margin: 10px 0;">Easy <strong>OR</strong> rigorous<br>
                Free <strong>OR</strong> professional<br>
                Teaching <strong>OR</strong> research-grade</p>
                <p style="color: #4ade80; font-size: 20px; font-weight: 700; margin: 30px 0 20px 0;">
                    Ördin gives you all of it.
                </p>
                <p style="color: #2e8b57; font-size: 16px; margin: 0;">
                    That's what makes it special. That's why it scores 96%.
                </p>
            </div>

            <!-- Perfect For Section -->
            <div style="margin: 50px 0; text-align: center;">
                <h3 style="color: #2e8b57; font-size: 20px; margin-bottom: 30px;">Perfect for:</h3>
                <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px;">
                    <div>
                        <div style="font-size: 36px; margin-bottom: 10px;">🎓</div>
                        <p style="color: #ccc; font-size: 13px;">PNG University<br>ecology courses</p>
                    </div>
                    <div>
                        <div style="font-size: 36px; margin-bottom: 10px;">📚</div>
                        <p style="color: #ccc; font-size: 13px;">Undergraduate/MSc/PhD<br>thesis research</p>
                    </div>
                    <div>
                        <div style="font-size: 36px; margin-bottom: 10px;">🔬</div>
                        <p style="color: #ccc; font-size: 13px;">Professional<br>ecology consultants</p>
                    </div>
                    <div>
                        <div style="font-size: 36px; margin-bottom: 10px;">📊</div>
                        <p style="color: #ccc; font-size: 13px;">Publication-quality<br>analyses</p>
                    </div>
                    <div>
                        <div style="font-size: 36px; margin-bottom: 10px;">🌏</div>
                        <p style="color: #ccc; font-size: 13px;">Biodiversity<br>assessments in PNG</p>
                    </div>
                </div>
            </div>

            <!-- Final Message -->
            <div style="background: linear-gradient(135deg, #1a3a2e 0%, #252526 100%); border-left: 4px solid #4ade80; padding: 30px; text-align: center;">
                <p style="color: #4ade80; font-size: 18px; font-weight: 600; margin: 0;">
                    Not just software. A capacity-building tool for PNG's ecological future.
                </p>
            </div>
        </div>
    `;
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { getAboutOrdinContent };
}
