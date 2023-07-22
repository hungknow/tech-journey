import React from 'react';
import logo from './logo.svg';
import { Route, Routes, useSearchParams } from "react-router-dom"

import './App.css';
import { Login } from './components/Login';
import { Error } from './components/Error';
import { Registration } from './components/Registration';

function App() {
  const [searchParams, setSearchParams] = useSearchParams()
  const flowId = searchParams.get("flow")
  const aal2 = searchParams.get("aal2")
  
  // Fetch flow id 
  return (
      <Routes>
        <Route path="/login" element={<Login flowId={flowId} aal2={aal2} />} />
        <Route path="/registration" element={<Registration />} />
        <Route path="/error" element={<Error />} />
      </Routes>
  );
}

export default App;
