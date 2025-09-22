import { useState } from 'react';
import { Form, redirect, Link } from 'react-router';

export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Library Management
          </h2>
          <p className="mt-2 text-center text-sm text-gray-600">
            Sign in to your account
          </p>
        </div>

        <Form method="post" className="mt-8 space-y-6">
          <div className="space-y-4">
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                Email
              </label>
              <div className="mt-1">
                <input id="email" name="email" type="email" required className="w-full px-3 py-2 border border-gray-300 text-gray-900 rounded-md"/>
              </div>
            </div>

            <div>
              <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                Password
              </label>
              <div className="mt-1">
                <input id="password" name="password" type='password' required className="w-full px-3 py-2 pr-10 border border-gray-300"/>
              </div>
            </div>
          </div>

          <div>
            <button type="submit" className="w-full flex justify-center py-2 px-4 border rounded-md text-white bg-blue-600">
              Sign In
            </button>
          </div>

          <div className="text-center">
            <span className="text-sm text-gray-600">
              Don't have an account?
              <Link to="/sign_up" className="ml-2 text-blue-600">
                Sign up here
              </Link>
            </span>
          </div>
        </Form>
      </div>
    </div>
  );
}
