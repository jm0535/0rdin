import * as React from 'react';

export class ErrorBoundary extends React.Component<{ children: React.ReactNode; fallback?: React.ReactNode }, { hasError: boolean; error: any }> {
  constructor(props: any) {
    super(props);
    this.state = { hasError: false, error: null };
  }
  static getDerivedStateFromError(error: any) {
    return { hasError: true, error };
  }
  componentDidCatch(error: any, info: any) {
    console.error('ErrorBoundary caught', error, info);
  }
  render() {
    if (this.state.hasError) {
      return this.props.fallback ?? (
        <div className="p-6 m-4 rounded-xl border border-[#d4a017]/30 bg-[#d4a0170a] text-sm">
          <div className="font-semibold text-[#d4a017]">⚠ Panel crashed — see console</div>
          <pre className="mt-2 text-xs bg-[#1e1e1e] p-2 rounded overflow-auto max-h-[300px]">{String(this.state.error?.message ?? this.state.error)}</pre>
          <pre className="mt-1 text-[11px] text-[#858585]">{String(this.state.error?.stack ?? '').slice(0, 2000)}</pre>
          <button className="mt-3 px-3 py-1 rounded bg-[#2e8b57] text-white text-xs" onClick={() => this.setState({ hasError: false, error: null })}>Retry</button>
        </div>
      );
    }
    return this.props.children;
  }
}
