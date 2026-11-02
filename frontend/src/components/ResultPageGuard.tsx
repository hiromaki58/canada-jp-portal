import React from "react";
import { Navigate, useLocation } from "react-router-dom";
import { useAuthProvider } from "../context/AuthContext";
import { ADMIN_PATHS } from "../cmn/Constant";

// State passed with navigate() when moving to a result page from inside the app.
export const RESULT_PAGE_STATE = { fromApp: true } as const;

type Props = {
    children: React.ReactElement;
};

// Result pages (e.g. /mc/login/success) are only shown after an in-app transition.
// Direct access (typed URL, bookmark) is redirected to the admin top page when logged in,
// otherwise to the login page.
// This only controls page flow; authorization must be enforced by the backend.
const ResultPageGuard: React.FC<Props> = ({ children }) => {
    const location = useLocation();
    const { isLoggedIn } = useAuthProvider();
    const state = location.state as { fromApp?: unknown } | null;

    if (state?.fromApp === true) {
        return children;
    }
    return <Navigate to={isLoggedIn ? ADMIN_PATHS.top : ADMIN_PATHS.login} replace />;
};

export default ResultPageGuard;
