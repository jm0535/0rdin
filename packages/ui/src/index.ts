import * as React from 'react';
export const Button = React.forwardRef<HTMLButtonElement, React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: 'default' | 'ghost' | 'outline' }>(
  ({ variant = 'default', className = '', ...props }, ref) => {
    const base = 'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none disabled:opacity-50';
    const variants: Record<string, string> = {
      default: 'bg-[#2e8b57] text-white hover:bg-[#257a4a] h-9 px-4',
      ghost: 'hover:bg-[#2a2a2a] hover:text-white h-9 px-3',
      outline: 'border border-[#3e3e42] bg-transparent hover:bg-[#2a2a2a] h-9 px-3',
    };
    return React.createElement('button', { ref, className: `${base} ${variants[variant]} ${className}`, ...props });
  }
);
Button.displayName = 'Button';

export const Card: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({ className = '', ...props }) =>
  React.createElement('div', { className: `rounded-lg border border-[#3e3e42] bg-[#252526] ${className}`, ...props });

export const Badge: React.FC<{ children: React.ReactNode; variant?: 'success' | 'info' | 'warn' }> = ({ children, variant = 'info' }) => {
  const map = { success: 'bg-[#2e8b5720] text-[#2e8b57]', info: 'bg-[#4a90e220] text-[#4a90e2]', warn: 'bg-[#d4a01720] text-[#d4a017]' } as const;
  return React.createElement('span', { className: `inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold ${map[variant]}` }, children);
};
