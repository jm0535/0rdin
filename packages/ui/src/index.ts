import * as React from 'react';

export const Button = React.forwardRef<HTMLButtonElement, React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: 'default' | 'ghost' | 'outline' | 'subtle' }>(
  ({ variant = 'default', className = '', ...props }, ref) => {
    const base = 'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none disabled:opacity-50 disabled:pointer-events-none';
    const variants: Record<string, string> = {
      default: 'bg-[#2e8b57] text-white hover:bg-[#257a4a] h-9 px-4 shadow-sm',
      ghost: 'hover:bg-[#2a2a2a] hover:text-white h-9 px-3',
      outline: 'border border-[#3e3e42] bg-transparent hover:bg-[#2a2a2a] h-9 px-3',
      subtle: 'bg-[#2d2d30] text-[#cccccc] hover:bg-[#3e3e42] h-8 px-3 text-xs',
    };
    return React.createElement('button', { ref, className: `${base} ${variants[variant]} ${className}`, ...props });
  }
);
Button.displayName = 'Button';

export const Card: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({ className = '', ...props }) =>
  React.createElement('div', { className: `rounded-xl border border-[#2d2d30] bg-[#252526] shadow-sm ${className}`, ...props });

export const Badge: React.FC<{ children: React.ReactNode; variant?: 'success' | 'info' | 'warn' | 'neutral'; className?: string }> = ({ children, variant = 'info', className = '' }) => {
  const map = { success: 'bg-[#2e8b5720] text-[#2e8b57] border border-[#2e8b57]/20', info: 'bg-[#4a90e220] text-[#4a90e2] border border-[#4a90e2]/15', warn: 'bg-[#d4a01720] text-[#d4a017] border border-[#d4a017]/20', neutral: 'bg-[#3e3e42] text-[#cccccc]' } as const;
  return React.createElement('span', { className: `inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${map[variant]} ${className}` }, children);
};

export const Input: React.FC<React.InputHTMLAttributes<HTMLInputElement>> = ({ className = '', ...props }) =>
  React.createElement('input', { className: `flex h-9 w-full rounded-md border border-[#3e3e42] bg-[#1e1e1e] px-3 py-1 text-sm text-[#cccccc] placeholder:text-[#858585] focus:outline-none focus:ring-1 focus:ring-[#2e8b57] ${className}`, ...props });

export const Separator: React.FC<{ orientation?: 'horizontal' | 'vertical'; className?: string }> = ({ orientation = 'horizontal', className = '' }) =>
  React.createElement('div', { className: orientation === 'horizontal' ? `h-px bg-[#2d2d30] ${className}` : `w-px bg-[#2d2d30] ${className}` });

// Minimal Dialog primitive — headless, controlled via open/onOpenChange, no external dep
export const Dialog: React.FC<{ open: boolean; onOpenChange: (o: boolean) => void; children: React.ReactNode }> = ({ open, onOpenChange, children }) => {
  if (!open) return null;
  return React.createElement(
    'div',
    { className: 'fixed inset-0 z-50 flex items-start justify-center pt-[12vh] p-4' },
    React.createElement('div', { className: 'fixed inset-0 bg-black/55 backdrop-blur-[2px]', onClick: () => onOpenChange(false) }),
    React.createElement('div', { className: 'relative w-full max-w-[640px] max-h-[70vh] flex flex-col rounded-xl border border-[#3e3e42] bg-[#252526] shadow-2xl overflow-hidden', role: 'dialog', 'aria-modal': true }, children)
  );
};
export const Sheet: React.FC<{ open: boolean; onOpenChange: (o: boolean) => void; side?: 'right' | 'left'; children: React.ReactNode }> = ({ open, onOpenChange, side = 'right', children }) => {
  if (!open) return null;
  const pos = side === 'right' ? 'right-0' : 'left-0';
  return React.createElement(
    'div',
    { className: 'fixed inset-0 z-40 flex' },
    React.createElement('div', { className: 'flex-1 bg-black/40 backdrop-blur-[1px]', onClick: () => onOpenChange(false) }),
    React.createElement('div', { className: `w-[360px] max-w-[90vw] h-full bg-[#252526] border-l border-[#2d2d30] shadow-2xl overflow-auto ${pos} animate-in slide-in-from-right` }, children)
  );
};
