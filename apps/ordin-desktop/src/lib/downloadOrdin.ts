import { useOrdinStore } from '@ordin/core';

/**
 * Download the current project as .ordin.json (auditable reproducible bundle).
 * Works in Tauri desktop and in pure browser preview.
 * Robust: appends anchor to DOM and delays revoke to avoid race.
 */
export function downloadOrdinJson() {
  try {
    const project = useOrdinStore.getState().project;
    const name = (project?.meta?.name || 'ordin').replace(/[^a-z0-9._-]/gi, '_');
    const json = JSON.stringify(project, null, 2);
    const blob = new Blob([json], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${name}.ordin.json`;
    // Firefox & preview iframes require anchor in DOM
    document.body.appendChild(a);
    a.click();
    a.remove();
    // delay revoke so download can start (especially in workers/iframes)
    setTimeout(() => URL.revokeObjectURL(url), 1500);
  } catch (err) {
    console.error('[Ordin] Export failed', err);
    // fallback: copy to clipboard hint
    alert('Export failed — check console. As fallback, use Details → Copy .ordin.json');
  }
}
