import { Card, Button } from '@ordin/ui';
import { Palette, Sliders, Download } from 'lucide-react';
import { useState } from 'react';

export type DiversityPlotSettings = {
  theme: 'bw'|'minimal'|'classic'|'light'|'dark'|'void';
  fontFamily: 'sans'|'serif'|'mono';
  baseSize: number;
  titleSize: number;
  axisTitleSize: number;
  lineSize: number;
  pointSize: number;
  showCI: boolean;
  ciAlpha: number;
  legendSize: number;
  legendRows: number;
  stripSize: number;
  axisLwd: number;
  showGridMinor: boolean;
  plotWidth: number;
  plotHeight: number;
  dpi: number;
  exportFormat: 'png'|'pdf'|'svg'|'tiff';
};

export const defaultDiversitySettings: DiversityPlotSettings = {
  theme: 'bw',
  fontFamily: 'sans',
  baseSize: 11,
  titleSize: 14,
  axisTitleSize: 12,
  lineSize: 1.5,
  pointSize: 2,
  showCI: true,
  ciAlpha: 0.3,
  legendSize: 8,
  legendRows: 2,
  stripSize: 11,
  axisLwd: 0.5,
  showGridMinor: false,
  plotWidth: 14,
  plotHeight: 6,
  dpi: 300,
  exportFormat: 'png',
};

export function DiversityPlotCustomization({ settings, onChange }: { settings: DiversityPlotSettings; onChange: (s: DiversityPlotSettings)=>void }) {
  const [open, setOpen] = useState(false);
  const update = (k: keyof DiversityPlotSettings, v: any) => onChange({ ...settings, [k]: v });
  return (
    <Card className="p-0 overflow-hidden border-[#3e3e42]">
      <button onClick={()=>setOpen(!open)} className="w-full flex items-center gap-2 px-3 py-2.5 bg-[#2d2d30] hover:bg-[#3e3e42] text-xs font-semibold tracking-widest">
        <Palette size={14} className="text-[#2e8b57]" /> PLOT CUSTOMIZATION — like previous Ördin (shiny)
        <span className="ml-auto text-[#858585] font-normal normal-case">{open ? 'Hide' : 'Show'} • theme, fonts, lines, CI, legend, export</span>
        <Sliders size={12} className={`text-[#858585] transition-transform ${open?'rotate-90':''}`} />
      </button>
      {open && (
        <div className="p-3 space-y-4 bg-[#1e1e1e]">
          <div className="grid md:grid-cols-3 gap-4">
            <div className="space-y-3">
              <h4 className="text-xs font-semibold text-[#2e8b57] flex items-center gap-1.5"><Palette size={12} /> Theme & Style</h4>
              <label className="block text-xs">Theme
                <select value={settings.theme} onChange={e=>update('theme', e.target.value)} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs">
                  <option value="bw">bw (Clean)</option>
                  <option value="minimal">Minimal</option>
                  <option value="classic">Classic</option>
                  <option value="light">Light</option>
                  <option value="dark">Dark</option>
                  <option value="void">Void</option>
                </select>
              </label>
              <label className="block text-xs">Font Family
                <select value={settings.fontFamily} onChange={e=>update('fontFamily', e.target.value)} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs">
                  <option value="sans">Sans</option>
                  <option value="serif">Serif</option>
                  <option value="mono">Mono</option>
                </select>
              </label>
              <label className="block text-xs">Base Font Size <input type="number" value={settings.baseSize} min={8} max={20} onChange={e=>update('baseSize', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="block text-xs">Title Size <input type="number" value={settings.titleSize} min={10} max={24} onChange={e=>update('titleSize', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="block text-xs">Axis Title Size <input type="number" value={settings.axisTitleSize} min={8} max={18} onChange={e=>update('axisTitleSize', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
            </div>
            <div className="space-y-3">
              <h4 className="text-xs font-semibold text-[#2e8b57]">Lines & Ribbons</h4>
              <label className="block text-xs">Line Width <input type="number" value={settings.lineSize} min={0.5} max={3} step={0.25} onChange={e=>update('lineSize', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="block text-xs">Point Size <input type="number" value={settings.pointSize} min={0.5} max={5} step={0.5} onChange={e=>update('pointSize', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="flex items-center gap-2 text-xs mt-2"><input type="checkbox" checked={settings.showCI} onChange={e=>update('showCI', e.target.checked)} className="accent-[#2e8b57]" /> Show CI Ribbons</label>
              <label className="block text-xs">CI Transparency <input type="number" value={settings.ciAlpha} min={0.1} max={1} step={0.1} onChange={e=>update('ciAlpha', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
            </div>
            <div className="space-y-3">
              <h4 className="text-xs font-semibold text-[#2e8b57]">Legend & Facets</h4>
              <label className="block text-xs">Legend Text Size <input type="number" value={settings.legendSize} min={6} max={16} onChange={e=>update('legendSize', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="block text-xs">Legend Rows <input type="number" value={settings.legendRows} min={1} max={5} onChange={e=>update('legendRows', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="block text-xs">Facet Label Size <input type="number" value={settings.stripSize} min={8} max={18} onChange={e=>update('stripSize', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="block text-xs">Axis Line Width <input type="number" value={settings.axisLwd} min={0.25} max={2} step={0.25} onChange={e=>update('axisLwd', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="flex items-center gap-2 text-xs"><input type="checkbox" checked={settings.showGridMinor} onChange={e=>update('showGridMinor', e.target.checked)} className="accent-[#2e8b57]" /> Minor Grid Lines</label>
            </div>
          </div>
          <div className="border-t border-[#2d2d30] pt-3">
            <h4 className="text-xs font-semibold text-[#2e8b57] flex items-center gap-1.5"><Download size={12} /> Export Settings</h4>
            <div className="grid grid-cols-4 gap-2 mt-2">
              <label className="text-xs">Width (in) <input type="number" value={settings.plotWidth} min={6} max={24} onChange={e=>update('plotWidth', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="text-xs">Height (in) <input type="number" value={settings.plotHeight} min={4} max={16} onChange={e=>update('plotHeight', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="text-xs">DPI <input type="number" value={settings.dpi} min={72} max={600} step={50} onChange={e=>update('dpi', Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="text-xs">Format
                <select value={settings.exportFormat} onChange={e=>update('exportFormat', e.target.value as any)} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs">
                  <option value="png">PNG</option><option value="pdf">PDF</option><option value="svg">SVG</option><option value="tiff">TIFF</option>
                </select>
              </label>
            </div>
            <div className="mt-3 flex gap-2">
              <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>{
                const blob = new Blob([`<svg xmlns='http://www.w3.org/2000/svg'><text>Ördin iNEXT export ${settings.exportFormat} ${settings.plotWidth}×${settings.plotHeight} @${settings.dpi}dpi</text></svg>`], {type: 'image/svg+xml'});
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href=url; a.download=`inext_plot_${new Date().toISOString().slice(0,10)}.${settings.exportFormat==='tiff'?'tiff':settings.exportFormat}`; a.click(); URL.revokeObjectURL(url);
              }}><Download size={12} className="mr-1" /> Export Plot ({settings.exportFormat.toUpperCase()} {settings.plotWidth}×{settings.plotHeight}@{settings.dpi})</Button>
              <Button variant="ghost" className="h-7 text-xs" onClick={()=>onChange(defaultDiversitySettings)}>Reset</Button>
            </div>
            <div className="text-[11px] text-[#858585] mt-2">Like previous Ördin (shiny): theme + fonts + sizes live-update — same knobs as <code>Shiny plot_defaults</code> (base_size, title_size, etc.). Real export would use <code>ggsave(width,height,dpi,device)</code> via webR.</div>
          </div>
        </div>
      )}
    </Card>
  );
}

export type OrdinationPlotSettings = {
  theme: string; fontFamily: string; baseSize: number; titleSize: number;
  pointSize: number; pointShape: string; pointColor: string; pointLwd: number;
  showEllipses: boolean; groupVar: string; ellipseType: string; ellipseLevel: number;
  plotType: string; showVectors: boolean; showSpecies: boolean;
  showGrid: boolean; showLabels: boolean; labelSize: number;
  plotWidth: number; plotHeight: number; dpi: number; exportFormat: string;
};
export const defaultOrdinationSettings: OrdinationPlotSettings = {
  theme:'bw', fontFamily:'sans', baseSize:12, titleSize:14,
  pointSize:2, pointShape:'21', pointColor:'#2e8b57', pointLwd:1.5,
  showEllipses:false, groupVar:'', ellipseType:'norm', ellipseLevel:0.95,
  plotType:'triplot', showVectors:true, showSpecies:true,
  showGrid:true, showLabels:false, labelSize:0.8,
  plotWidth:8, plotHeight:6, dpi:300, exportFormat:'png'
};
export function OrdinationPlotCustomization({ settings, onChange }: { settings: OrdinationPlotSettings; onChange:(s:OrdinationPlotSettings)=>void}) {
  const [open,setOpen]=useState(false);
  const upd=(k:keyof OrdinationPlotSettings,v:any)=>onChange({...settings,[k]:v});
  return (
    <Card className="p-0 overflow-hidden border-[#3e3e42]">
      <button onClick={()=>setOpen(!open)} className="w-full flex items-center gap-2 px-3 py-2.5 bg-[#2d2d30] hover:bg-[#3e3e42] text-xs font-semibold tracking-widest">
        <Palette size={14} className="text-[#4a90e2]" /> ORDINATION PLOT CUSTOMIZATION — triplot / biplot
        <span className="ml-auto text-[#858585] font-normal normal-case">{open?'Hide':'Show'} • points, ellipses, vectors, export</span>
      </button>
      {open && (
        <div className="p-3 space-y-4 bg-[#1e1e1e]">
          <div className="grid md:grid-cols-3 gap-4">
            <div className="space-y-2">
              <h4 className="text-xs font-semibold text-[#4a90e2]">Theme & Style</h4>
              <label className="block text-xs">Theme <select value={settings.theme} onChange={e=>upd('theme',e.target.value)} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs"><option value="bw">bw</option><option value="minimal">minimal</option><option value="classic">classic</option><option value="light">light</option><option value="dark">dark</option><option value="void">void</option></select></label>
              <label className="block text-xs">Base Size <input type="number" value={settings.baseSize} min={8} max={20} onChange={e=>upd('baseSize',Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
            </div>
            <div className="space-y-2">
              <h4 className="text-xs font-semibold text-[#4a90e2]">Points</h4>
              <label className="block text-xs">Point Size <input type="number" value={settings.pointSize} min={0.5} max={5} step={0.5} onChange={e=>upd('pointSize',Number(e.target.value))} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" /></label>
              <label className="block text-xs">Point Color <select value={settings.pointColor} onChange={e=>upd('pointColor',e.target.value)} className="mt-1 w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs"><option value="#2e8b57">Ördin Green</option><option value="#007acc">Blue</option><option value="#d4a017">Orange</option><option value="#e74c3c">Red</option><option value="#9b59b6">Purple</option></select></label>
            </div>
            <div className="space-y-2">
              <h4 className="text-xs font-semibold text-[#4a90e2]">Ellipses & Vectors</h4>
              <label className="flex items-center gap-2 text-xs"><input type="checkbox" checked={settings.showEllipses} onChange={e=>upd('showEllipses',e.target.checked)} className="accent-[#4a90e2]" /> Show Ellipses</label>
              <label className="flex items-center gap-2 text-xs"><input type="checkbox" checked={settings.showVectors} onChange={e=>upd('showVectors',e.target.checked)} className="accent-[#4a90e2]" /> Show Vectors</label>
              <label className="flex items-center gap-2 text-xs"><input type="checkbox" checked={settings.showSpecies} onChange={e=>upd('showSpecies',e.target.checked)} className="accent-[#4a90e2]" /> Show Species</label>
            </div>
          </div>
          <div className="flex gap-2">
            <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>{
              const blob=new Blob([`<svg xmlns='http://www.w3.org/2000/svg'><text>Ordination ${settings.pointColor} triplot export</text></svg>`],{type:'image/svg+xml'});
              const url=URL.createObjectURL(blob); const a=document.createElement('a'); a.href=url; a.download=`ordination_${new Date().toISOString().slice(0,10)}.${settings.exportFormat}`; a.click(); URL.revokeObjectURL(url);
            }}><Download size={12} className="mr-1" /> Export {settings.exportFormat.toUpperCase()}</Button>
            <Button variant="ghost" className="h-7 text-xs" onClick={()=>onChange(defaultOrdinationSettings)}>Reset</Button>
          </div>
        </div>
      )}
    </Card>
  );
}
