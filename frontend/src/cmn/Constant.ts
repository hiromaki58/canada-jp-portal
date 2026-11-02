// Empty by default so API calls go to the same origin ("/api/...").
// - Local: the Vite dev server proxies "/api" to the backend (see vite.config.ts).
// - AWS: route "/api" to the backend on the same domain (ALB / reverse proxy).
// Set VITE_API_BASE_URL at build time only when the API is served from a different origin.
export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? "";

// Base path of the remitter API on the backend (e.g. `${REMITTER_API}/login`)
export const REMITTER_API = `${API_BASE_URL}/api/remitter`;

// The current site is the admin area and is served under "/mc"; the public top page stays at "/".
export const ADMIN_BASE_PATH = "/mc";
export const ADMIN_PATHS = {
    top: ADMIN_BASE_PATH,
    login: `${ADMIN_BASE_PATH}/login`,
    loginSuccess: `${ADMIN_BASE_PATH}/login/success`,
    loginFail: `${ADMIN_BASE_PATH}/login/fail`,
    registration: `${ADMIN_BASE_PATH}/registration`,
    registrationSuccess: `${ADMIN_BASE_PATH}/registration/success`,
    registrationFail: `${ADMIN_BASE_PATH}/registration/fail`,
    profile: `${ADMIN_BASE_PATH}/profile`,
} as const;
