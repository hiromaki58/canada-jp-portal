import React from "react";
import { Link } from "react-router-dom";
import "../css/jobs.css";

type Props = {
    children: React.ReactNode;
};

// Header and footer for the public pages (job board). The admin pages under /mc use Header / Footer.
const PublicLayout: React.FC<Props> = ({ children }) => {
    return (
        <div className="pub">
            <header className="pub-header">
                <div className="pub-header-in">
                    <Link className="pub-logo" to="/">
                        <span className="pub-logo-mark" aria-hidden="true">CJ</span>
                        <span className="pub-logo-text">Canada JP Portal</span>
                    </Link>
                    <nav className="pub-nav" aria-label="グローバルナビゲーション">
                        <ul>
                            <li><Link to="/">お仕事を探す</Link></li>
                            <li><a href="/#about">ポータルについて</a></li>
                            <li><a className="pub-btn pub-btn-primary pub-btn-sm" href="/#contact">お問い合わせ</a></li>
                        </ul>
                    </nav>
                </div>
            </header>
            <main className="pub-main">{children}</main>
            <footer className="pub-footer">
                <div className="pub-footer-in">
                    <div className="pub-footer-brand">
                        <p className="pub-footer-logo">Canada JP Portal</p>
                        <p className="pub-footer-lead">カナダで働きたい日本人と、日本語人材を求める企業をつなぐ。</p>
                    </div>
                    <ul className="pub-footer-links">
                        <li><Link to="/">お仕事を探す</Link></li>
                        <li><a href="/#about">ポータルについて</a></li>
                        <li><a href="https://github.com/hiromaki58/canada-jp-portal" rel="noopener noreferrer">GitHub</a></li>
                    </ul>
                </div>
                <p className="pub-footer-copyright">&copy; Hiroyuki Maki. All Rights Reserved.</p>
            </footer>
        </div>
    );
};

export default PublicLayout;
