import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import IndexPage from "./pages/IndexPage";
import LoginPage from "./pages/login/LoginPage";
import LoginSuccessPage from "./pages/login/LoginSuccess";
import LoginFailPage from "./pages/login/LoginFail";
import RegistrationPage from "./pages/registration/RegistrationPage";
import RegistrationSuccessPage from "./pages/registration/RegistrationSuccess";
import RegistrationFailPage from "./pages/registration/RegistrationFail";
import NotFoundPage from "./pages/404Page";
import ResultPageGuard from "./components/ResultPageGuard";
import JobListPage from "./pages/jobs/JobListPage";
import JobDetailPage from "./pages/jobs/JobDetailPage";
import { ADMIN_PATHS } from "./cmn/Constant";

const App: React.FC = () => {
	return (
		<AuthProvider>
			<Router>
				<Routes>
					<Route path="/" element={<JobListPage />} />
					<Route path="/jobs/:id" element={<JobDetailPage />} />
					<Route path={ADMIN_PATHS.top} element={<IndexPage />} />
					<Route path={ADMIN_PATHS.login} element={<LoginPage />} />
					<Route path={ADMIN_PATHS.loginSuccess} element={<ResultPageGuard><LoginSuccessPage /></ResultPageGuard>} />
					<Route path={ADMIN_PATHS.loginFail} element={<ResultPageGuard><LoginFailPage /></ResultPageGuard>} />
					<Route path={ADMIN_PATHS.registration} element={<RegistrationPage />} />
					<Route path={ADMIN_PATHS.registrationSuccess} element={<ResultPageGuard><RegistrationSuccessPage /></ResultPageGuard>} />
					<Route path={ADMIN_PATHS.registrationFail} element={<ResultPageGuard><RegistrationFailPage /></ResultPageGuard>} />
					<Route path="*" element={<NotFoundPage />} />
				</Routes>
			</Router>
		</AuthProvider>
	);
};

export default App;
