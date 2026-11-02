import React from "react";
import { useAuthProvider } from "../context/AuthContext";
import { Link } from "react-router-dom";
import { ADMIN_PATHS } from "../cmn/Constant";
import "../css/base-pc.css";

const Header: React.FC = () => {
    const { isLoggedIn, logout } = useAuthProvider();

    return (
        <header className="header">
            <div className="header-in only-pc">
                <section>
                    <h1 className="header-logo logo-company">
                        <Link to={ADMIN_PATHS.top}><img src="/img/logo_institution_01.jpg" alt="site logo" /></Link>
                    </h1>
                    <nav className="nav-global">
                        <ul>
                            {isLoggedIn ? (
                                <>
                                    <li onClick={logout} ><Link to={ADMIN_PATHS.top}><span className="nav-global-in-first">logout</span></Link></li>
                                    <li><Link to={ADMIN_PATHS.profile}><span className="nav-global-in">profile</span></Link></li>
                                </>
                            ) : (
                                <>
                                    <li><Link to={ADMIN_PATHS.login}><span className="nav-global-in-first">login</span></Link></li>
                                    <li><Link to={ADMIN_PATHS.registration}><span className="nav-global-in">registration</span></Link></li>
                                </>
                            )}
                        </ul>
                    </nav>
                </section>
            </div>
        </header>
    );
};

export default Header;
